import { randomUUID } from 'node:crypto';
import { envelopeSchema, type EntitySpec } from './entities.js';
import { HttpError } from './lib/errors.js';
import type { ApiRecord } from './repositories/sync-repository.js';

/**
 * Validates an incoming record for [spec]. Missing id/updatedAt are filled in so plain REST
 * clients don't have to send sync metadata; the mobile app always sends both.
 */
export function toRecord(spec: EntitySpec, input: unknown, overrides: { id?: string } = {}): ApiRecord {
  const body = (input ?? {}) as Record<string, unknown>;
  const envelope = envelopeSchema.parse({
    id: overrides.id ?? body.id ?? randomUUID(),
    updatedAt: body.updatedAt ?? Date.now(),
    deleted: body.deleted ?? false,
  });
  const fields = spec.schema.parse(body) as Record<string, unknown>;
  const record: ApiRecord = { ...fields, ...envelope };
  checkBusinessRules(spec, record);
  return record;
}

function checkBusinessRules(spec: EntitySpec, record: ApiRecord): void {
  if (spec.name === 'groupExpenses') {
    const shares = record.shares as Record<string, number>;
    const total = Object.values(shares).reduce((sum, share) => sum + share, 0);
    if (Object.keys(shares).length === 0) {
      throw HttpError.badRequest('An expense needs at least one member to split with');
    }
    if (total !== record.amountMinor) {
      throw HttpError.badRequest(`Shares add up to ${total} but the expense amount is ${record.amountMinor}`);
    }
  }
  if (spec.name === 'settlements' && record.fromMember === record.toMember) {
    throw HttpError.badRequest('A member cannot settle with themselves');
  }
}
