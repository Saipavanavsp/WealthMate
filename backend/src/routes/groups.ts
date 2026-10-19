import { Router } from 'express';
import type { Db } from '../db/database.js';
import { specFor } from '../entities.js';
import { HttpError } from '../lib/errors.js';
import { currentUser } from '../middleware.js';
import { SyncRepository } from '../repositories/sync-repository.js';
import {
  computeBalances,
  simplifyDebts,
  type ExpenseLike,
  type SettlementLike,
} from '../services/debt-simplifier.js';

/** Read-only group summary: net balances plus the simplified "who pays whom" list. */
export function groupSummaryRoutes(db: Db): Router {
  const groups = new SyncRepository(db, specFor('groups'));
  const members = new SyncRepository(db, specFor('groupMembers'));
  const expenses = new SyncRepository(db, specFor('groupExpenses'));
  const settlements = new SyncRepository(db, specFor('settlements'));
  const router = Router();

  router.get('/:id/balances', (req, res) => {
    const userId = currentUser(req).id;
    const group = groups.find(userId, req.params.id);
    if (!group || group.deleted) throw HttpError.notFound('Group not found');

    const filter = { groupId: group.id };
    const memberList = members.list(userId, filter);
    const balances = computeBalances(
      memberList.map((m) => m.id),
      expenses.list(userId, filter) as unknown as ExpenseLike[],
      settlements.list(userId, filter) as unknown as SettlementLike[],
    );
    const names = new Map(memberList.map((m) => [m.id, m.name as string]));

    res.json({
      data: {
        groupId: group.id,
        currency: group.currency,
        balances: [...balances].map(([memberId, amountMinor]) => ({
          memberId,
          name: names.get(memberId) ?? 'Unknown',
          amountMinor,
        })),
        suggestedTransfers: simplifyDebts(balances).map((t) => ({
          ...t,
          fromName: names.get(t.from) ?? 'Unknown',
          toName: names.get(t.to) ?? 'Unknown',
        })),
      },
    });
  });

  return router;
}
