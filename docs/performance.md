# Performance notes

## Chart aggregation: a profiling find

The Insights screen sums every transaction into monthly bars, weekly bars and a category
breakdown. That work runs in a background isolate (`compute`), so slow aggregation never drops
frames, but it still delays when the charts appear.

`tool/analytics_benchmark.dart` compares three implementations over the same random data
(12 monthly bars, 12 weekly bars and a category breakdown). Median of 9 runs on a Windows laptop
in JIT mode:

| Transactions | Filter per bucket (naive) | First single-pass draft | Current |
|---:|---:|---:|---:|
| 1,000 | 0.50 ms | 6.65 ms | 0.33 ms |
| 10,000 | 1.99 ms | 65.45 ms | 0.55 ms |
| 50,000 | 35.44 ms | 923.33 ms | 2.12 ms |

The first draft was the "obvious" optimisation: one pass, with hash buckets keyed by the year/month
or week start of each transaction. It was **26× slower than the naive version** it was meant to beat.
Profiling showed nearly all of the time going into `DateTime` construction and field access. Building a
local-time `DateTime`, or reading `.year`/`.month`/`.weekday` from one, needs a timezone lookup, and
that happened 2–3 times per transaction.

The fix was to compute the period boundaries once, as epoch milliseconds, and place each
transaction with a binary search over those integers. That is O(n log b) with no allocations
per item, **435× faster than the first draft and 17× faster than the naive version** at 50k rows.
The same change was applied to the health-score calculator and the dashboard's month filter.

Reproduce:

```bash
cd app
dart run tool/analytics_benchmark.dart
```

## Rebuild scoping

- `buildWhen` on list and form builders, so a failure message or a filter change doesn't rebuild
  unrelated widgets. For example, `TransactionsPage` ignores failure-only state changes.
- `BlocSelector` for single values: the submit button only watches `submitting`, and the
  segmented filter only watches `filter`.
- `context.select` for the greeting name on the dashboard instead of watching the whole auth state.
- `ListView.builder` for the transactions list, so only visible rows are built.
- `const` constructors throughout, enforced by the `prefer_const_constructors` lint.

## Database

- Indexes on `transactions.occurred_at` and on the group foreign keys. The outbox has a unique index
  on `(entity, record_id)`, so the coalescing upsert is a single indexed write.
- The group screens re-query only when one of the four group tables changes
  (`tableUpdates`), instead of polling.
- Demo data is inserted with a single `batch`, not row by row.

## How to profile on a device

1. `flutter run --profile` on a physical Android device. Debug mode numbers are meaningless.
2. Open DevTools → **Performance**. Enable "Track widget builds", then scroll the Activity list and
   switch the Insights period. Look for frames over 16 ms on the UI or raster thread.
3. DevTools → **CPU Profiler**: record while the Insights screen opens with a large history
   (sign in to the seeded backend account, or add rows through the API).
4. Widget rebuild counts: the Flutter Inspector's "Rebuild stats" shows whether `buildWhen`
   and `BlocSelector` keep rebuilds local when you type in the add-transaction form.
