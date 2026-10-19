import { createApp } from './app.js';
import { loadConfig } from './config.js';
import { openDatabase } from './db/database.js';
import { seedIfEmpty } from './db/seed.js';

const config = loadConfig();
const db = openDatabase(config.databasePath);

if (config.autoSeed && seedIfEmpty(db)) {
  console.log('Seeded demo data (demo@wealthmate.app / Demo@1234)');
}

const server = createApp(db, config).listen(config.port, () => {
  console.log(`WealthMate API listening on http://localhost:${config.port} (docs at /docs)`);
});

function shutdown() {
  server.close(() => {
    db.close();
    process.exit(0);
  });
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
