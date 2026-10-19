import request from 'supertest';
import { describe, expect, it } from 'vitest';
import { DEMO_EMAIL, DEMO_PASSWORD, seedDemoUser } from '../src/db/seed.js';
import { signUp, testApp } from './helpers.js';

const expense = (overrides: Record<string, unknown> = {}) => ({
  id: 'tx-1',
  type: 'expense',
  amountMinor: 45000,
  category: 'Food',
  merchant: 'Swiggy',
  occurredAt: 1_700_000_000_000,
  updatedAt: 1_700_000_000_000,
  ...overrides,
});

describe('auth', () => {
  it('registers, logs in and rotates refresh tokens', async () => {
    const { app } = testApp();
    const session = await signUp(app);

    await request(app).post('/api/v1/auth/login').send({ email: 'sai@example.com', password: 'Password1' }).expect(200);
    await request(app).post('/api/v1/auth/login').send({ email: 'sai@example.com', password: 'wrong-pass' }).expect(401);

    const refreshed = await request(app).post('/api/v1/auth/refresh').send({ refreshToken: session.refreshToken }).expect(200);
    expect(refreshed.body.accessToken).toBeTruthy();
    // the old refresh token is single use
    await request(app).post('/api/v1/auth/refresh').send({ refreshToken: session.refreshToken }).expect(401);
  });

  it('rejects requests without a token', async () => {
    const { app } = testApp();
    await request(app).get('/api/v1/transactions').expect(401);
  });

  it('rejects duplicate emails', async () => {
    const { app } = testApp();
    await signUp(app);
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'SAI@example.com', password: 'Password1', name: 'Sai' })
      .expect(409);
  });
});

describe('transactions', () => {
  it('creates, lists, updates and deletes', async () => {
    const { app } = testApp();
    const { accessToken } = await signUp(app);
    const auth = { Authorization: `Bearer ${accessToken}` };

    await request(app).post('/api/v1/transactions').set(auth).send(expense()).expect(201);
    const list = await request(app).get('/api/v1/transactions').set(auth).expect(200);
    expect(list.body.data).toHaveLength(1);

    await request(app)
      .put('/api/v1/transactions/tx-1')
      .set(auth)
      .send(expense({ amountMinor: 50000, updatedAt: 1_700_000_000_500 }))
      .expect(200);

    await request(app).delete('/api/v1/transactions/tx-1').set(auth).expect(204);
    await request(app).get('/api/v1/transactions/tx-1').set(auth).expect(404);
  });

  it('validates input', async () => {
    const { app } = testApp();
    const { accessToken } = await signUp(app);
    const res = await request(app)
      .post('/api/v1/transactions')
      .set('Authorization', `Bearer ${accessToken}`)
      .send(expense({ amountMinor: -5 }))
      .expect(400);
    expect(res.body.error.code).toBe('validation_failed');
  });

  it("does not expose another user's data", async () => {
    const { app } = testApp();
    const sai = await signUp(app, 'sai@example.com');
    const ravi = await signUp(app, 'ravi@example.com');
    await request(app).post('/api/v1/transactions').set('Authorization', `Bearer ${sai.accessToken}`).send(expense()).expect(201);
    await request(app).get('/api/v1/transactions/tx-1').set('Authorization', `Bearer ${ravi.accessToken}`).expect(404);
  });
});

describe('sync', () => {
  it('applies newer writes and reports stale ones as conflicts', async () => {
    const { app } = testApp();
    const { accessToken } = await signUp(app);
    const auth = { Authorization: `Bearer ${accessToken}` };

    const first = await request(app)
      .post('/api/v1/sync/push')
      .set(auth)
      .send({ changes: [{ changeId: 1, entity: 'transactions', record: expense({ updatedAt: 2000 }) }] })
      .expect(200);
    expect(first.body.results[0].status).toBe('applied');

    const stale = await request(app)
      .post('/api/v1/sync/push')
      .set(auth)
      .send({ changes: [{ changeId: 2, entity: 'transactions', record: expense({ amountMinor: 1, updatedAt: 1000 }) }] })
      .expect(200);
    expect(stale.body.results[0].status).toBe('conflict');
    expect(stale.body.results[0].record.amountMinor).toBe(45000);
  });

  it('rejects one bad change without failing the batch', async () => {
    const { app } = testApp();
    const { accessToken } = await signUp(app);
    const res = await request(app)
      .post('/api/v1/sync/push')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        changes: [
          { changeId: 1, entity: 'transactions', record: expense({ amountMinor: -1 }) },
          { changeId: 2, entity: 'transactions', record: expense({ id: 'tx-2' }) },
        ],
      })
      .expect(200);
    expect(res.body.results.map((r: { status: string }) => r.status)).toEqual(['rejected', 'applied']);
  });

  it('pulls only changes after the cursor, including deletions', async () => {
    const { app } = testApp();
    const { accessToken } = await signUp(app);
    const auth = { Authorization: `Bearer ${accessToken}` };

    await request(app).post('/api/v1/transactions').set(auth).send(expense()).expect(201);
    const full = await request(app).get('/api/v1/sync/pull?since=0').set(auth).expect(200);
    expect(full.body.changes.transactions).toHaveLength(1);

    const empty = await request(app).get(`/api/v1/sync/pull?since=${full.body.cursor}`).set(auth).expect(200);
    expect(empty.body.changes).toEqual({});

    await request(app).delete('/api/v1/transactions/tx-1').set(auth).expect(204);
    const after = await request(app).get(`/api/v1/sync/pull?since=${full.body.cursor}`).set(auth).expect(200);
    expect(after.body.changes.transactions[0].deleted).toBe(true);
  });
});

describe('groups', () => {
  it('returns simplified settlements for the seeded trip', async () => {
    const { app, db } = testApp();
    seedDemoUser(db);
    const login = await request(app).post('/api/v1/auth/login').send({ email: DEMO_EMAIL, password: DEMO_PASSWORD }).expect(200);
    const auth = { Authorization: `Bearer ${login.body.accessToken}` };

    const groups = await request(app).get('/api/v1/groups').set(auth).expect(200);
    const res = await request(app).get(`/api/v1/groups/${groups.body.data[0].id}/balances`).set(auth).expect(200);

    const total = res.body.data.balances.reduce((sum: number, b: { amountMinor: number }) => sum + b.amountMinor, 0);
    expect(total).toBe(0);
    expect(res.body.data.suggestedTransfers.length).toBeLessThanOrEqual(3);
  });

  it('rejects an expense whose shares do not add up', async () => {
    const { app } = testApp();
    const { accessToken } = await signUp(app);
    const res = await request(app)
      .post('/api/v1/group-expenses')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        groupId: 'g1',
        description: 'Dinner',
        amountMinor: 1000,
        paidBy: 'm1',
        splitType: 'custom',
        shares: { m1: 500, m2: 400 },
        occurredAt: 1,
      })
      .expect(400);
    expect(res.body.error.message).toContain('Shares add up to 900');
  });
});
