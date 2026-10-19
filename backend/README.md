# WealthMate API

Express + TypeScript service that backs the WealthMate app: JWT auth, CRUD endpoints, and the
push/pull sync protocol the mobile app uses to stay offline-first.

It uses Node's built-in `node:sqlite` module, so there is no native module to compile and no
database server to install.

## Run it

```bash
cd backend
npm install
npm run dev          # http://localhost:8080, Swagger UI at /docs
```

On first start the database is created at `./data/wealthmate.db` and seeded with a demo account:

| Email | Password |
|---|---|
| `demo@wealthmate.app` | `Demo@1234` |

The seed has six months of transactions, three savings goals and a "Goa Trip" group with shared
expenses. Run `npm run seed` to reset it at any time.

Configuration is through environment variables (see `.env.example`). Node 22.13+ is required.

```bash
npm test             # vitest + supertest, runs against an in-memory database
npm run typecheck
npm run build && npm start
```

## Endpoints

All routes are under `/api/v1`. Everything except `/auth/*` needs `Authorization: Bearer <token>`.
The full OpenAPI spec is in [`docs/openapi.yaml`](docs/openapi.yaml) and served at `/docs`.

| Method | Path | Notes |
|---|---|---|
| POST | `/auth/register` | Returns `{ user, accessToken, refreshToken, expiresIn }` |
| POST | `/auth/login` | |
| POST | `/auth/refresh` | Rotates the refresh token (single use) |
| POST | `/auth/logout` | Revokes the refresh token |
| GET | `/auth/me` | |
| GET/POST | `/transactions` | |
| GET/PUT/DELETE | `/transactions/:id` | DELETE writes a tombstone |
| GET/POST | `/goals`, `/groups`, `/group-members`, `/group-expenses`, `/settlements` | Same shape as transactions; list endpoints accept field filters, e.g. `?groupId=` |
| GET | `/groups/:id/balances` | Net balances and the simplified "who pays whom" list |
| POST | `/sync/push` | Batch of outbox entries, each answered `applied`, `conflict` or `rejected` |
| GET | `/sync/pull?since=<cursor>` | Every change after the cursor, tombstones included |

## Design notes

- **Amounts** are integers in paise. **Timestamps** are epoch milliseconds. **IDs** are UUIDs generated
  by the client, so records can be created offline and pushed later without remapping IDs.
- **One generic repository** (`SyncRepository`) handles every synced table from a small field spec in
  `entities.ts`. Adding an entity means adding a spec and a table, not new data-access code.
- **Last-write-wins:** a write is applied only if its `updatedAt` is strictly newer than the stored one.
  On a tie the server copy wins, so every device converges on the same value.
- **Change cursor:** every write takes the next value of a global sequence (`seq`). Clients pull with
  `?since=<last cursor>`. This is reliable even when device clocks disagree, because the cursor comes
  from the server, not from timestamps.
- **Partial batches:** in `/sync/push` an invalid entry is reported as `rejected` without failing the
  rest of the batch, so one bad record can't block a device's whole queue.
- **Passwords** are hashed with scrypt from `node:crypto`. Refresh tokens are stored as SHA-256 hashes.

## Deploying

`render.yaml` in the repository root is a Render blueprint for this service. After deploying, set the
API URL as the `API_BASE_URL` repository variable on GitHub (for example
`https://wealthmate-api.onrender.com/api/v1`). The web and APK workflows then build against it.
