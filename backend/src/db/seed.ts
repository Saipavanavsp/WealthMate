import { randomUUID } from 'node:crypto';
import { pathToFileURL } from 'node:url';
import { loadConfig } from '../config.js';
import { specFor, type EntityName } from '../entities.js';
import { hashPassword } from '../lib/crypto.js';
import { SyncRepository } from '../repositories/sync-repository.js';
import { inTransaction, openDatabase, type Db } from './database.js';

export const DEMO_EMAIL = 'demo@wealthmate.app';
export const DEMO_PASSWORD = 'Demo@1234';

const DAY = 24 * 60 * 60 * 1000;

/** Small deterministic PRNG (mulberry32) so the seed produces the same data every run. */
function prng(seed: number) {
  return () => {
    seed = (seed + 0x6d2b79f5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

const spending: { category: string; merchants: string[]; min: number; max: number; perMonth: number }[] = [
  { category: 'Food', merchants: ['Swiggy', 'Zomato', 'Starbucks', 'Dominos'], min: 150, max: 900, perMonth: 9 },
  { category: 'Groceries', merchants: ['BigBasket', 'DMart', 'Zepto', 'Blinkit'], min: 300, max: 2500, perMonth: 5 },
  { category: 'Transport', merchants: ['Uber', 'Ola', 'Rapido', 'IndianOil'], min: 80, max: 1200, perMonth: 7 },
  { category: 'Shopping', merchants: ['Amazon', 'Flipkart', 'Myntra'], min: 400, max: 4500, perMonth: 2 },
  { category: 'Entertainment', merchants: ['BookMyShow', 'PVR'], min: 200, max: 1200, perMonth: 1 },
  { category: 'Health', merchants: ['Apollo Pharmacy', 'PharmEasy'], min: 150, max: 1500, perMonth: 1 },
];

export function seedDemoUser(db: Db, now = Date.now()): string {
  const rand = prng(42);
  const between = (min: number, max: number) => Math.round(min + rand() * (max - min));
  const userId = randomUUID();

  inTransaction(db, () => {
    db.prepare('DELETE FROM users WHERE email = ?').run(DEMO_EMAIL);
    db.prepare('INSERT INTO users (id, email, name, password_hash, created_at) VALUES (?, ?, ?, ?, ?)').run(
      userId,
      DEMO_EMAIL,
      'Demo User',
      hashPassword(DEMO_PASSWORD),
      now,
    );

    const repos = new Map<EntityName, SyncRepository>();
    const save = (entity: EntityName, record: Record<string, unknown>) => {
      if (!repos.has(entity)) repos.set(entity, new SyncRepository(db, specFor(entity)));
      const id = (record.id as string | undefined) ?? randomUUID();
      repos.get(entity)!.upsert(userId, { ...record, id, updatedAt: now, deleted: false });
      return id;
    };

    for (let monthsAgo = 5; monthsAgo >= 0; monthsAgo--) {
      const start = new Date(now);
      start.setDate(1);
      start.setHours(9, 0, 0, 0);
      start.setMonth(start.getMonth() - monthsAgo);
      const monthStart = start.getTime();
      const daysInMonth = monthsAgo === 0 ? new Date(now).getDate() : 28;

      save('transactions', {
        type: 'income',
        amountMinor: 85_000_00,
        currency: 'INR',
        category: 'Salary',
        merchant: 'Acme Technologies',
        note: 'Monthly salary',
        occurredAt: monthStart,
        recurrence: 'monthly',
      });
      save('transactions', {
        type: 'expense',
        amountMinor: 22_000_00,
        currency: 'INR',
        category: 'Rent',
        merchant: 'House rent',
        note: null,
        occurredAt: monthStart + 2 * DAY,
        recurrence: 'monthly',
      });
      save('transactions', {
        type: 'expense',
        amountMinor: 1_499_00,
        currency: 'INR',
        category: 'Bills',
        merchant: 'Airtel Broadband',
        note: null,
        occurredAt: monthStart + 5 * DAY,
        recurrence: 'monthly',
      });

      for (const item of spending) {
        for (let i = 0; i < item.perMonth; i++) {
          const day = between(0, Math.max(daysInMonth - 1, 0));
          save('transactions', {
            type: 'expense',
            amountMinor: between(item.min, item.max) * 100,
            currency: 'INR',
            category: item.category,
            merchant: item.merchants[between(0, item.merchants.length - 1)],
            note: null,
            occurredAt: monthStart + day * DAY + between(0, 12) * 60 * 60 * 1000,
            recurrence: 'none',
          });
        }
      }
    }

    save('goals', { name: 'Emergency fund', targetMinor: 3_00_000_00, savedMinor: 1_65_000_00, currency: 'INR', deadline: now + 240 * DAY });
    save('goals', { name: 'New laptop', targetMinor: 1_20_000_00, savedMinor: 45_000_00, currency: 'INR', deadline: now + 150 * DAY });
    save('goals', { name: 'Goa trip', targetMinor: 40_000_00, savedMinor: 32_000_00, currency: 'INR', deadline: now + 45 * DAY });

    const groupId = save('groups', { name: 'Goa Trip', currency: 'INR' });
    const [you, ravi, priya, arjun] = ['You', 'Ravi', 'Priya', 'Arjun'].map((name) =>
      save('groupMembers', { groupId, name }),
    ) as [string, string, string, string];
    const everyone = [you, ravi, priya, arjun];
    const equally = (amount: number) => Object.fromEntries(everyone.map((m) => [m, amount / everyone.length]));

    save('groupExpenses', {
      groupId,
      description: 'Villa booking',
      amountMinor: 24_000_00,
      paidBy: you,
      splitType: 'equal',
      shares: equally(24_000_00),
      occurredAt: now - 20 * DAY,
    });
    save('groupExpenses', {
      groupId,
      description: 'Scooter rental',
      amountMinor: 4_800_00,
      paidBy: ravi,
      splitType: 'equal',
      shares: equally(4_800_00),
      occurredAt: now - 19 * DAY,
    });
    save('groupExpenses', {
      groupId,
      description: 'Seafood dinner',
      amountMinor: 6_000_00,
      paidBy: priya,
      splitType: 'custom',
      shares: { [you]: 1_500_00, [ravi]: 2_000_00, [priya]: 1_000_00, [arjun]: 1_500_00 },
      occurredAt: now - 18 * DAY,
    });
    save('settlements', { groupId, fromMember: arjun, toMember: you, amountMinor: 3_000_00, occurredAt: now - 10 * DAY });
  });

  return userId;
}

/** Seeds the demo account when the database has no users yet. Returns true if it seeded. */
export function seedIfEmpty(db: Db): boolean {
  const row = db.prepare('SELECT COUNT(*) AS count FROM users').get() as { count: number };
  if (row.count > 0) return false;
  seedDemoUser(db);
  return true;
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? '').href) {
  const db = openDatabase(loadConfig().databasePath);
  seedDemoUser(db);
  db.close();
  console.log(`Demo data reset. Sign in with ${DEMO_EMAIL} / ${DEMO_PASSWORD}`);
}
