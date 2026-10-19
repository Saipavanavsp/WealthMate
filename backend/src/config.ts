function int(value: string | undefined, fallback: number): number {
  const parsed = Number.parseInt(value ?? '', 10);
  return Number.isFinite(parsed) ? parsed : fallback;
}

export interface Config {
  port: number;
  databasePath: string;
  jwtSecret: string;
  accessTokenTtlSeconds: number;
  refreshTokenTtlDays: number;
  corsOrigins: string[] | '*';
  autoSeed: boolean;
}

export function loadConfig(env: NodeJS.ProcessEnv = process.env): Config {
  const origins = env.CORS_ORIGINS ?? '*';
  return {
    port: int(env.PORT, 8080),
    databasePath: env.DATABASE_PATH ?? './data/wealthmate.db',
    jwtSecret: env.JWT_SECRET ?? 'dev-only-secret',
    accessTokenTtlSeconds: int(env.ACCESS_TOKEN_TTL_SECONDS, 900),
    refreshTokenTtlDays: int(env.REFRESH_TOKEN_TTL_DAYS, 30),
    corsOrigins: origins === '*' ? '*' : origins.split(',').map((o) => o.trim()),
    autoSeed: (env.AUTO_SEED ?? 'true') === 'true',
  };
}
