import type { ErrorRequestHandler, NextFunction, Request, RequestHandler, Response } from 'express';
import { ZodError, type z, type ZodTypeAny } from 'zod';
import { HttpError } from './lib/errors.js';
import type { AuthService, PublicUser } from './services/auth-service.js';

declare module 'express-serve-static-core' {
  interface Request {
    user?: PublicUser;
  }
}

export function requireAuth(auth: AuthService): RequestHandler {
  return (req: Request, _res: Response, next: NextFunction) => {
    const header = req.header('authorization') ?? '';
    const [scheme, token] = header.split(' ');
    if (scheme !== 'Bearer' || !token) throw HttpError.unauthorized();
    req.user = auth.verifyAccessToken(token);
    next();
  };
}

export function currentUser(req: Request): PublicUser {
  if (!req.user) throw HttpError.unauthorized();
  return req.user;
}

export function parse<S extends ZodTypeAny>(schema: S, value: unknown): z.output<S> {
  return schema.parse(value);
}

export const errorHandler: ErrorRequestHandler = (error, _req, res, _next) => {
  if (error instanceof ZodError) {
    res.status(400).json({
      error: { code: 'validation_failed', message: 'Request validation failed', details: error.flatten() },
    });
    return;
  }
  if (error instanceof HttpError) {
    res.status(error.status).json({ error: { code: error.code, message: error.message, details: error.details } });
    return;
  }
  if (error instanceof SyntaxError && 'body' in error) {
    res.status(400).json({ error: { code: 'invalid_json', message: 'Request body is not valid JSON' } });
    return;
  }
  console.error(error);
  res.status(500).json({ error: { code: 'internal', message: 'Something went wrong' } });
};

export const notFound: RequestHandler = (_req, res) => {
  res.status(404).json({ error: { code: 'not_found', message: 'Route not found' } });
};
