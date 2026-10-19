import type { Db } from '../db/database.js';
import { nextSeq } from '../db/database.js';
import type { EntitySpec } from '../entities.js';

export type ApiRecord = Record<string, unknown> & {
  id: string;
  updatedAt: number;
  deleted: boolean;
};

export type UpsertResult =
  | { status: 'applied'; record: ApiRecord }
  | { status: 'conflict'; record: ApiRecord };

type Row = Record<string, unknown>;

/**
 * Generic data access for any synced table described by an [EntitySpec].
 *
 * Conflict rule (last-write-wins): an incoming write is applied only if its
 * `updatedAt` is strictly newer than what the server already has. On a tie the
 * server copy wins, so two devices always converge on the same value.
 */
export class SyncRepository {
  constructor(
    private readonly db: Db,
    private readonly spec: EntitySpec,
  ) {}

  list(userId: string, filter: Record<string, string> = {}): ApiRecord[] {
    const clauses = ['user_id = ?', 'deleted = 0'];
    const params: string[] = [userId];
    for (const [key, value] of Object.entries(filter)) {
      const field = this.spec.fields[key];
      if (!field) continue;
      clauses.push(`${field.column} = ?`);
      params.push(value);
    }
    const orderBy = this.spec.fields.occurredAt ? 'occurred_at DESC' : 'updated_at DESC';
    const rows = this.db
      .prepare(`SELECT * FROM ${this.spec.table} WHERE ${clauses.join(' AND ')} ORDER BY ${orderBy}`)
      .all(...params) as Row[];
    return rows.map((row) => this.toApi(row));
  }

  find(userId: string, id: string): ApiRecord | undefined {
    const row = this.findRow(id);
    if (!row || row.user_id !== userId) return undefined;
    return this.toApi(row);
  }

  /** Insert or update. Must be called inside a transaction (it bumps the change sequence). */
  upsert(userId: string, record: ApiRecord): UpsertResult {
    const existing = this.findRow(record.id);
    if (existing && existing.user_id !== userId) {
      // Ids are client generated UUIDs; a clash with another user's row is treated as a conflict
      // without leaking that row.
      return { status: 'conflict', record: { ...record } };
    }
    if (existing && (existing.updated_at as number) >= record.updatedAt) {
      return { status: 'conflict', record: this.toApi(existing) };
    }

    const seq = nextSeq(this.db);
    const columns = ['id', 'user_id', 'updated_at', 'deleted', 'seq'];
    const values: (string | number | null)[] = [record.id, userId, record.updatedAt, record.deleted ? 1 : 0, seq];
    for (const [key, field] of Object.entries(this.spec.fields)) {
      columns.push(field.column);
      const value = record[key];
      if (value === undefined || value === null) {
        values.push(null);
      } else if (field.kind === 'json') {
        values.push(JSON.stringify(value));
      } else {
        values.push(value as string | number);
      }
    }
    const placeholders = columns.map(() => '?').join(', ');
    const updates = columns
      .filter((c) => c !== 'id')
      .map((c) => `${c} = excluded.${c}`)
      .join(', ');
    this.db
      .prepare(
        `INSERT INTO ${this.spec.table} (${columns.join(', ')}) VALUES (${placeholders})
         ON CONFLICT(id) DO UPDATE SET ${updates}`,
      )
      .run(...values);

    return { status: 'applied', record: this.toApi(this.findRow(record.id)!) };
  }

  /** Soft delete (tombstone) so the deletion reaches other devices on their next pull. */
  remove(userId: string, id: string, updatedAt: number): UpsertResult | undefined {
    const current = this.find(userId, id);
    if (!current) return undefined;
    return this.upsert(userId, { ...current, deleted: true, updatedAt });
  }

  changesSince(userId: string, seq: number): ApiRecord[] {
    const rows = this.db
      .prepare(`SELECT * FROM ${this.spec.table} WHERE user_id = ? AND seq > ? ORDER BY seq`)
      .all(userId, seq) as Row[];
    return rows.map((row) => this.toApi(row));
  }

  private findRow(id: string): Row | undefined {
    return this.db.prepare(`SELECT * FROM ${this.spec.table} WHERE id = ?`).get(id) as Row | undefined;
  }

  private toApi(row: Row): ApiRecord {
    const record: ApiRecord = {
      id: row.id as string,
      updatedAt: row.updated_at as number,
      deleted: row.deleted === 1,
    };
    for (const [key, field] of Object.entries(this.spec.fields)) {
      const value = row[field.column];
      record[key] = field.kind === 'json' && typeof value === 'string' ? JSON.parse(value) : value;
    }
    return record;
  }
}
