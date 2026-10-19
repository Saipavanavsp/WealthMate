export class HttpError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message: string,
    readonly details?: unknown,
  ) {
    super(message);
    this.name = 'HttpError';
  }

  static badRequest(message: string, details?: unknown) {
    return new HttpError(400, 'bad_request', message, details);
  }

  static unauthorized(message = 'Authentication required') {
    return new HttpError(401, 'unauthorized', message);
  }

  static notFound(message = 'Not found') {
    return new HttpError(404, 'not_found', message);
  }

  static conflict(message: string, details?: unknown) {
    return new HttpError(409, 'conflict', message, details);
  }
}
