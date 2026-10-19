/**
 * Every synced table carries the same bookkeeping columns:
 *  - updated_at: client timestamp (ms) of the last edit, used for last-write-wins
 *  - deleted:    tombstone flag so deletes can be synced to other devices
 *  - seq:        server-assigned, strictly increasing change number; clients pull with `?since=<seq>`
 */
export const schemaSql = `
CREATE TABLE IF NOT EXISTS users (
  id            TEXT PRIMARY KEY,
  email         TEXT NOT NULL UNIQUE,
  name          TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  created_at    INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS refresh_tokens (
  token_hash TEXT PRIMARY KEY,
  user_id    TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  expires_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS change_seq (
  id    INTEGER PRIMARY KEY CHECK (id = 1),
  value INTEGER NOT NULL
);
INSERT OR IGNORE INTO change_seq (id, value) VALUES (1, 0);

CREATE TABLE IF NOT EXISTS transactions (
  id           TEXT PRIMARY KEY,
  user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type         TEXT NOT NULL CHECK (type IN ('expense', 'income')),
  amount_minor INTEGER NOT NULL CHECK (amount_minor >= 0),
  currency     TEXT NOT NULL DEFAULT 'INR',
  category     TEXT NOT NULL,
  merchant     TEXT,
  note         TEXT,
  occurred_at  INTEGER NOT NULL,
  recurrence   TEXT NOT NULL DEFAULT 'none' CHECK (recurrence IN ('none', 'weekly', 'monthly')),
  updated_at   INTEGER NOT NULL,
  deleted      INTEGER NOT NULL DEFAULT 0,
  seq          INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_transactions_user_seq ON transactions (user_id, seq);
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions (user_id, occurred_at);

CREATE TABLE IF NOT EXISTS goals (
  id           TEXT PRIMARY KEY,
  user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name         TEXT NOT NULL,
  target_minor INTEGER NOT NULL CHECK (target_minor > 0),
  saved_minor  INTEGER NOT NULL DEFAULT 0 CHECK (saved_minor >= 0),
  currency     TEXT NOT NULL DEFAULT 'INR',
  deadline     INTEGER NOT NULL,
  updated_at   INTEGER NOT NULL,
  deleted      INTEGER NOT NULL DEFAULT 0,
  seq          INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_goals_user_seq ON goals (user_id, seq);

CREATE TABLE IF NOT EXISTS groups (
  id         TEXT PRIMARY KEY,
  user_id    TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name       TEXT NOT NULL,
  currency   TEXT NOT NULL DEFAULT 'INR',
  updated_at INTEGER NOT NULL,
  deleted    INTEGER NOT NULL DEFAULT 0,
  seq        INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_groups_user_seq ON groups (user_id, seq);

CREATE TABLE IF NOT EXISTS group_members (
  id         TEXT PRIMARY KEY,
  user_id    TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  group_id   TEXT NOT NULL,
  name       TEXT NOT NULL,
  updated_at INTEGER NOT NULL,
  deleted    INTEGER NOT NULL DEFAULT 0,
  seq        INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_group_members_user_seq ON group_members (user_id, seq);

CREATE TABLE IF NOT EXISTS group_expenses (
  id           TEXT PRIMARY KEY,
  user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  group_id     TEXT NOT NULL,
  description  TEXT NOT NULL,
  amount_minor INTEGER NOT NULL CHECK (amount_minor > 0),
  paid_by      TEXT NOT NULL,
  split_type   TEXT NOT NULL CHECK (split_type IN ('equal', 'custom')),
  shares       TEXT NOT NULL,
  occurred_at  INTEGER NOT NULL,
  updated_at   INTEGER NOT NULL,
  deleted      INTEGER NOT NULL DEFAULT 0,
  seq          INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_group_expenses_user_seq ON group_expenses (user_id, seq);

CREATE TABLE IF NOT EXISTS settlements (
  id           TEXT PRIMARY KEY,
  user_id      TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  group_id     TEXT NOT NULL,
  from_member  TEXT NOT NULL,
  to_member    TEXT NOT NULL,
  amount_minor INTEGER NOT NULL CHECK (amount_minor > 0),
  occurred_at  INTEGER NOT NULL,
  updated_at   INTEGER NOT NULL,
  deleted      INTEGER NOT NULL DEFAULT 0,
  seq          INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_settlements_user_seq ON settlements (user_id, seq);
`;
