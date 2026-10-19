import { readFileSync } from 'node:fs';
import cors from 'cors';
import express, { type Express } from 'express';
import helmet from 'helmet';
import swaggerUi from 'swagger-ui-express';
import { parse as parseYaml } from 'yaml';
import type { Config } from './config.js';
import type { Db } from './db/database.js';
import { entityNames, specFor } from './entities.js';
import { errorHandler, notFound, requireAuth } from './middleware.js';
import { authRoutes } from './routes/auth.js';
import { groupSummaryRoutes } from './routes/groups.js';
import { resourceRoutes } from './routes/resources.js';
import { syncRoutes } from './routes/sync.js';
import { AuthService } from './services/auth-service.js';

/** groupMembers -> group-members */
const toPath = (name: string) => name.replace(/[A-Z]/g, (c) => `-${c.toLowerCase()}`);

export function createApp(db: Db, config: Config): Express {
  const app = express();
  const auth = new AuthService(db, config);

  app.disable('x-powered-by');
  app.use(helmet({ contentSecurityPolicy: false }));
  app.use(cors({ origin: config.corsOrigins === '*' ? true : config.corsOrigins }));
  app.use(express.json({ limit: '1mb' }));

  app.get('/health', (_req, res) => {
    res.json({ status: 'ok', time: new Date().toISOString() });
  });

  const openApi = parseYaml(readFileSync(new URL('../docs/openapi.yaml', import.meta.url), 'utf8'));
  app.use('/docs', swaggerUi.serve, swaggerUi.setup(openApi, { customSiteTitle: 'WealthMate API' }));
  app.get('/', (_req, res) => res.redirect('/docs'));

  const api = express.Router();
  api.use('/auth', authRoutes(auth));
  api.use(requireAuth(auth));
  api.use('/sync', syncRoutes(db));
  api.use('/groups', groupSummaryRoutes(db));
  for (const name of entityNames) {
    api.use(`/${toPath(name)}`, resourceRoutes(db, specFor(name)));
  }
  app.use('/api/v1', api);

  app.use(notFound);
  app.use(errorHandler);
  return app;
}
