# Git workflow

- `main` is always releasable. Every push runs CI and redeploys the web demo.
- Work happens on short-lived branches named `<type>/<scope>`, merged with `--no-ff` so each feature
  appears as one unit in the history.
- Commits follow [Conventional Commits](https://www.conventionalcommits.org/): `feat`, `fix`, `test`,
  `docs`, `ci`, `chore`, `perf`, `refactor`, with an optional scope (`feat(sync): ...`).

## Branches and PR descriptions per phase

| Phase | Branch | PR title |
|---|---|---|
| 1 | `chore/project-setup` | chore: Flutter project with strict lints, theme, routing and DI |
| 2 | `feat/backend-api` | feat(backend): Express API with JWT auth, sync endpoints and seed data |
| 3 | `feat/local-database` | feat(core): Drift schema, Money value object and repositories |
| 4 | `feat/sync-engine` | feat(sync): Dio client, outbox queue and last-write-wins sync |
| 5 | `feat/auth` | feat(auth): sign-in, demo mode and biometric lock |
| 6 | `feat/transactions` | feat(transactions): tracking, auto-categorisation and charts |
| 7 | `feat/goals-health-score` | feat(goals): savings goals and financial health score |
| 8 | `feat/group-expenses` | feat(groups): group splits and debt simplification |
| 9 | `feat/reminders-l10n` | feat: reminders, background jobs, Telugu/Hindi, CSV export |
| 10 | `perf/profiling-pass` | perf: profiling pass and fixes |
| 11 | `docs/readme` | docs: README, architecture and release notes |

### Example PR description (phase 4)

> **What and why**
> Adds the networking layer and the sync engine, so changes made offline reach the server and
> changes from other devices come back.
>
> **How**
> - Dio client with three interceptors: auth (queued, refreshes the JWT once on a 401 and retries),
>   retry (exponential backoff with jitter for idempotent calls) and logging (debug builds only).
>   Transport errors map to typed `Failure`s.
> - `SyncQueueStore`: an outbox table written in the same transaction as the data. FIFO by
>   autoincrement id; repeat edits to one record merge into a single entry and keep its place in the queue.
> - `SyncEngine`: push in batches of 100, then pull with the server cursor. Last-write-wins on
>   `updatedAt`. Runs are single-flight.
>
> **Testing**
> In-memory Drift with a fake server that applies the real LWW rule: batching, conflicts in both
> directions, rejected entries, tombstones and concurrent calls.
