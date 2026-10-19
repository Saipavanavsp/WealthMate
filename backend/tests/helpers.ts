import request from 'supertest';
import { createApp } from '../src/app.js';
import { loadConfig } from '../src/config.js';
import { openDatabase } from '../src/db/database.js';

export function testApp() {
  const db = openDatabase(':memory:');
  const app = createApp(db, loadConfig({ JWT_SECRET: 'test-secret', DATABASE_PATH: ':memory:' }));
  return { app, db };
}

export async function signUp(app: ReturnType<typeof testApp>['app'], email = 'sai@example.com') {
  const res = await request(app)
    .post('/api/v1/auth/register')
    .send({ email, password: 'Password1', name: 'Sai' })
    .expect(201);
  return res.body as { accessToken: string; refreshToken: string; user: { id: string } };
}
