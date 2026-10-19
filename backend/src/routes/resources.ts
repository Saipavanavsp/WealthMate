import { Router } from 'express';
import type { Db } from '../db/database.js';
import { inTransaction } from '../db/database.js';
import type { EntitySpec } from '../entities.js';
import { HttpError } from '../lib/errors.js';
import { currentUser } from '../middleware.js';
import { toRecord } from '../records.js';
import { SyncRepository } from '../repositories/sync-repository.js';

/**
 * Standard CRUD endpoints for a synced entity. Writes go through the same
 * last-write-wins path as /sync/push, so REST and sync clients can't disagree.
 */
export function resourceRoutes(db: Db, spec: EntitySpec): Router {
  const repo = new SyncRepository(db, spec);
  const router = Router();

  router.get('/', (req, res) => {
    const filter: Record<string, string> = {};
    for (const [key, value] of Object.entries(req.query)) {
      if (typeof value === 'string') filter[key] = value;
    }
    res.json({ data: repo.list(currentUser(req).id, filter) });
  });

  router.get('/:id', (req, res) => {
    const record = repo.find(currentUser(req).id, req.params.id);
    if (!record || record.deleted) throw HttpError.notFound();
    res.json({ data: record });
  });

  router.post('/', (req, res) => {
    const record = toRecord(spec, req.body);
    const result = inTransaction(db, () => repo.upsert(currentUser(req).id, record));
    if (result.status === 'conflict') {
      throw HttpError.conflict('A newer version of this record already exists', result.record);
    }
    res.status(201).json({ data: result.record });
  });

  router.put('/:id', (req, res) => {
    const userId = currentUser(req).id;
    if (!repo.find(userId, req.params.id)) throw HttpError.notFound();
    const record = toRecord(spec, req.body, { id: req.params.id });
    const result = inTransaction(db, () => repo.upsert(userId, record));
    if (result.status === 'conflict') {
      throw HttpError.conflict('A newer version of this record already exists', result.record);
    }
    res.json({ data: result.record });
  });

  router.delete('/:id', (req, res) => {
    const result = inTransaction(db, () => repo.remove(currentUser(req).id, req.params.id, Date.now()));
    if (!result) throw HttpError.notFound();
    res.status(204).end();
  });

  return router;
}
