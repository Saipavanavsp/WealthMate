import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import '../../features/auth/domain/entities/session.dart';
import 'session_store.dart';

/// Adds the bearer token and transparently refreshes it on a 401.
///
/// It's a [QueuedInterceptor], so when several requests fail with 401 at once
/// only the first one refreshes; the rest wait and reuse the new token.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required SessionStore sessions, required Dio refreshClient, required Dio retryClient})
    : _sessions = sessions,
      _refreshClient = refreshClient,
      _retryClient = retryClient;

  final SessionStore _sessions;
  final Dio _refreshClient;
  final Dio _retryClient;

  static const _retriedKey = 'auth_retried';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _sessions.current?.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final session = _sessions.current;
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    if (err.response?.statusCode != 401 || session?.refreshToken == null || alreadyRetried) {
      return handler.next(err);
    }

    try {
      // Another queued request may have refreshed already.
      var current = _sessions.current!;
      if (current.accessToken == session!.accessToken) {
        current = await _refresh(current);
      }
      final options = err.requestOptions
        ..headers['Authorization'] = 'Bearer ${current.accessToken}'
        ..extra[_retriedKey] = true;
      handler.resolve(await _retryClient.fetch<dynamic>(options));
    } on DioException catch (refreshError) {
      if (refreshError.response?.statusCode == 401) await _sessions.clear();
      handler.next(err);
    }
  }

  Future<Session> _refresh(Session session) async {
    final response = await _refreshClient.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refreshToken': session.refreshToken},
    );
    final data = response.data!;
    final updated = session.copyWith(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    await _sessions.save(updated);
    return updated;
  }
}

/// Retries requests that failed for transient reasons (connection drop,
/// timeout, 502/503/504) with exponential backoff plus jitter:
/// 400ms, 800ms, 1.6s ... capped at [maxDelay].
///
/// Only idempotent requests are retried. Sync pushes count as idempotent
/// because replaying one is resolved by last-write-wins on the server.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 400),
    this.maxDelay = const Duration(seconds: 8),
    Random? random,
    Future<void> Function(Duration)? sleep,
  }) : _dio = dio,
       _random = random ?? Random(),
       _sleep = sleep ?? Future<void>.delayed;

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;
  final Random _random;
  final Future<void> Function(Duration) _sleep;

  static const _attemptKey = 'retry_attempt';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;
    if (attempt >= maxRetries || !_isTransient(err) || !_isIdempotent(options)) {
      return handler.next(err);
    }

    await _sleep(delayFor(attempt));
    options.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Duration delayFor(int attempt) {
    final exponential = baseDelay.inMilliseconds * pow(2, attempt);
    final jitter = _random.nextInt(baseDelay.inMilliseconds);
    return Duration(milliseconds: min(exponential.toInt() + jitter, maxDelay.inMilliseconds));
  }

  bool _isTransient(DioException err) {
    return switch (err.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => true,
      DioExceptionType.badResponse => const {502, 503, 504}.contains(err.response?.statusCode),
      _ => false,
    };
  }

  bool _isIdempotent(RequestOptions options) {
    const safe = {'GET', 'PUT', 'DELETE', 'HEAD'};
    return safe.contains(options.method.toUpperCase()) || options.path.endsWith('/sync/push');
  }
}
