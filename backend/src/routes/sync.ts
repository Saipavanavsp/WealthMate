import { Router } from 'express';
import { z } from 'zod';
import type { Db } from '../db/database.js';
import { currentSeq, inTransaction } from '../db/database.js';
import { entityNames, specFor, type EntityName } from '../entities.js';
import { currentUser, parse } from '../middleware.js';
import { toRecord } from '../records.js';
import { SyncRepository, type ApiRecord } from '../repositories/sync-repository.js';

const pushBody = z.object({
  changes: z
    .array(
      z.object({
        // Client-side outbox id, echoed back so the client knows which entries to drop.
        changeId: z.union([z.number().int(), z.string()]),
        entity: z.enum(entityNames as [EntityName, ...EntityName[]]),
        record: z.record(z.unknown()),
      }),
    )
    .max(500),
});

const pullQuery = z.object({ since: z.coerce.number().int().nonnegative().default(0) });

export function syncRoutes(db: Db): Router {
  const repos = new Map(entityNames.map((name) => [name, new SyncRepository(db, specFor(name))]));
  const router = Router();

  /**
   * Applies a batch of outbox entries in the order they were sent. Each entry is
   * either applied or reported as a conflict carrying the server's copy; a bad entry
   * is rejected on its own without failing the whole batch.
   */
  router.post('/push', (req, res) => {
    const userId = currentUser(req).id;
    const { changes } = parse(pushBody, req.body);

    const results = inTransaction(db, () =>
      changes.map((change) => {
        try {
          const record = toRecord(specFor(change.entity), change.record);
          const outcome = repos.get(change.entity)!.upsert(userId, record);
          return { changeId: change.changeId, status: outcome.status, record: outcome.record };
        } catch (error) {
          return {
            changeId: change.changeId,
            status: 'rejected' as const,
            reason: error instanceof Error ? error.message : 'Invalid record',
          };
        }
      }),
    );

    res.json({ results, cursor: currentSeq(db) });
  });

  /** Everything that changed after [since], grouped by entity, plus the cursor for the next pull. */
  router.get('/pull', (req, res) => {
    const userId = currentUser(req).id;
    const { since } = parse(pullQuery, req.query);
    const cursor = currentSeq(db);
    const changes: Partial<Record<EntityName, ApiRecord[]>> = {};
    for (const [name, repo] of repos) {
      const rows = repo.changesSince(userId, since);
      if (rows.length > 0) changes[name] = rows;
    }
    res.json({ changes, cursor });
  });

  return router;
}
