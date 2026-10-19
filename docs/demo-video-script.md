# Demo video script (about 3 minutes)

Record on an Android emulator or phone, with the backend running locally and seeded.

**0:00 Intro (15s)**
"This is WealthMate, an offline-first personal finance app I built in Flutter. It tracks spending,
shared expenses and savings goals, and it keeps working without a connection."

**0:15 Sign in and dashboard (25s)**
Sign in as `demo@wealthmate.app`. Point out this month's net, income and expenses, and the
financial health score. Expand the score: "It's built from three parts, savings rate, spending trend
and goal progress, and the app explains each one in plain language."

**0:40 Add an expense offline (40s)**
Turn on airplane mode. Tap *Add transaction*, type 250 and "Swiggy". "The category is suggested by a
rules engine as I type." Save. The cloud icon now shows a pending change.
"The UI only reads from the local SQLite database, so this works with no network. The change is
written to an outbox in the same transaction."
Turn airplane mode off. The icon flips to synced. Optionally show the record in Swagger UI.

**1:20 Insights (20s)**
Open Insights and switch between monthly and weekly. "Aggregation runs in a background isolate. A
profiling pass made it 435 times faster; the write-up is in the repo."

**1:40 Group expenses (40s)**
Open the Goa Trip group. "Four people and several expenses, but only three payments settle
everything. The app matches the biggest creditor with the biggest debtor using two max-heaps,
which needs at most n − 1 transfers." Tap *Mark paid* on one transfer and show the balances update.
Add an expense split by shares (2:1:1).

**2:20 Goals and reminders (20s)**
Show a goal ring and the suggested monthly contribution, then the bill reminders list.

**2:40 Settings (15s)**
Switch to dark mode, then to Telugu or Hindi. Export the CSV.

**2:55 Close (5s)**
"The code, tests and architecture notes are on GitHub. Thanks for watching."
