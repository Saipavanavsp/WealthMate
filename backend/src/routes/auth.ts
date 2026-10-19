import { Router } from 'express';
import { z } from 'zod';
import { currentUser, parse, requireAuth } from '../middleware.js';
import type { AuthService } from '../services/auth-service.js';

const credentials = z.object({
  email: z.string().email(),
  password: z.string().min(8, 'Password must be at least 8 characters'),
});

const registration = credentials.extend({ name: z.string().min(1).max(60) });
const refreshBody = z.object({ refreshToken: z.string().min(1) });

export function authRoutes(auth: AuthService): Router {
  const router = Router();

  router.post('/register', (req, res) => {
    const body = parse(registration, req.body);
    res.status(201).json(auth.register(body.email, body.password, body.name));
  });

  router.post('/login', (req, res) => {
    const body = parse(credentials, req.body);
    res.json(auth.login(body.email, body.password));
  });

  router.post('/refresh', (req, res) => {
    const body = parse(refreshBody, req.body);
    res.json(auth.refresh(body.refreshToken));
  });

  router.post('/logout', (req, res) => {
    const body = parse(refreshBody, req.body);
    auth.logout(body.refreshToken);
    res.status(204).end();
  });

  router.get('/me', requireAuth(auth), (req, res) => {
    res.json({ user: currentUser(req) });
  });

  return router;
}
