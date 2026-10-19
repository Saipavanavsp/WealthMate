import { mkdirSync } from 'node:fs';
import { dirname } from 'node:path';
import { DatabaseSync } from 'node:sqlite';
import { schemaSql } from './schema.js';

export type Db = DatabaseSync;

export function openDatabase(path: string): Db {
  if (path !== ':memory:') {
    mkdirSync(dirname(path), { recursive: true });
  }
  const db = new DatabaseSync(path);
  db.exec('PRAGMA foreign_keys = ON;');
  if (path !== ':memory:') {
    db.exec('PRAGMA journal_mode = WAL;');
  }
  db.exec(schemaSql);
  return db;
}

/** Runs [work] inside a transaction, rolling back if it throws. */
export function inTransaction<T>(db: Db, work: () => T): T {
  db.exec('BEGIN');
  try {
    const result = work();
    db.exec('COMMIT');
    return result;
  } catch (error) {
    db.exec('ROLLBACK');
    throw error;
  }
}

/** Returns the next value of the global change sequence. Call inside a transaction. */
export function nextSeq(db: Db): number {
  const row = db
    .prepare('UPDATE change_seq SET value = value + 1 WHERE id = 1 RETURNING value')
    .get() as { value: number };
  return row.value;
}

export function currentSeq(db: Db): number {
  const row = db.prepare('SELECT value FROM change_seq WHERE id = 1').get() as { value: number };
  return row.value;
}
