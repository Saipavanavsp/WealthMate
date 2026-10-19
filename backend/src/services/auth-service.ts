import { randomUUID } from 'node:crypto';
import jwt from 'jsonwebtoken';
import type { Config } from '../config.js';
import type { Db } from '../db/database.js';
import { hashPassword, randomToken, sha256, verifyPassword } from '../lib/crypto.js';
import { HttpError } from '../lib/errors.js';

export interface PublicUser {
  id: string;
  email: string;
  name: string;
}

export interface Session {
  user: PublicUser;
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

interface UserRow {
  id: string;
  email: string;
  name: string;
  password_hash: string;
}

export class AuthService {
  constructor(
    private readonly db: Db,
    private readonly config: Config,
  ) {}

  register(email: string, password: string, name: string): Session {
    const normalised = email.trim().toLowerCase();
    const taken = this.db.prepare('SELECT 1 FROM users WHERE email = ?').get(normalised);
    if (taken) throw HttpError.conflict('An account with this email already exists');

    const user: PublicUser = { id: randomUUID(), email: normalised, name: name.trim() };
    this.db
      .prepare('INSERT INTO users (id, email, name, password_hash, created_at) VALUES (?, ?, ?, ?, ?)')
      .run(user.id, user.email, user.name, hashPassword(password), Date.now());
    return this.issueSession(user);
  }

  login(email: string, password: string): Session {
    const row = this.db
      .prepare('SELECT * FROM users WHERE email = ?')
      .get(email.trim().toLowerCase()) as UserRow | undefined;
    if (!row || !verifyPassword(password, row.password_hash)) {
      throw HttpError.unauthorized('Incorrect email or password');
    }
    return this.issueSession({ id: row.id, email: row.email, name: row.name });
  }

  /** Refresh tokens are single use: the presented token is revoked and a new pair issued. */
  refresh(refreshToken: string): Session {
    const hash = sha256(refreshToken);
    const row = this.db
      .prepare(
        `SELECT u.id, u.email, u.name, t.expires_at FROM refresh_tokens t
         JOIN users u ON u.id = t.user_id WHERE t.token_hash = ?`,
      )
      .get(hash) as (PublicUser & { expires_at: number }) | undefined;
    this.db.prepare('DELETE FROM refresh_tokens WHERE token_hash = ?').run(hash);
    if (!row || row.expires_at < Date.now()) {
      throw HttpError.unauthorized('Session expired, please sign in again');
    }
    return this.issueSession({ id: row.id, email: row.email, name: row.name });
  }

  logout(refreshToken: string): void {
    this.db.prepare('DELETE FROM refresh_tokens WHERE token_hash = ?').run(sha256(refreshToken));
  }

  verifyAccessToken(token: string): PublicUser {
    try {
      const payload = jwt.verify(token, this.config.jwtSecret) as jwt.JwtPayload;
      return { id: payload.sub as string, email: payload.email as string, name: payload.name as string };
    } catch {
      throw HttpError.unauthorized('Invalid or expired access token');
    }
  }

  private issueSession(user: PublicUser): Session {
    const accessToken = jwt.sign({ email: user.email, name: user.name }, this.config.jwtSecret, {
      subject: user.id,
      expiresIn: this.config.accessTokenTtlSeconds,
    });
    const refreshToken = randomToken();
    const expiresAt = Date.now() + this.config.refreshTokenTtlDays * 24 * 60 * 60 * 1000;
    this.db
      .prepare('INSERT INTO refresh_tokens (token_hash, user_id, expires_at) VALUES (?, ?, ?)')
      .run(sha256(refreshToken), user.id, expiresAt);
    return { user, accessToken, refreshToken, expiresIn: this.config.accessTokenTtlSeconds };
  }
}
