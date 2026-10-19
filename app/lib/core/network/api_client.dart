import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../error/failures.dart';
import 'interceptors.dart';
import 'session_store.dart';

/// Builds the configured [Dio] instance used by every remote data source.
Dio createApiClient(AppConfig config, SessionStore sessions) {
  BaseOptions options() => BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    contentType: Headers.jsonContentType,
  );

  final dio = Dio(options());
  // Separate clients so refresh and retry calls don't run through the
  // interceptors that triggered them.
  final bare = Dio(options());

  dio.interceptors.addAll([
    AuthInterceptor(sessions: sessions, refreshClient: bare, retryClient: bare),
    RetryInterceptor(dio: bare),
    if (kDebugMode) LogInterceptor(requestBody: true, logPrint: (o) => debugPrint('$o')),
  ]);
  return dio;
}

/// Maps transport errors to the [Failure] types the UI understands.
Failure mapDioError(Object error) {
  if (error is! DioException) return const UnexpectedFailure();
  final message = _serverMessage(error.response?.data);
  return switch (error.type) {
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => const TimeoutFailure(),
    DioExceptionType.badResponse => switch (error.response?.statusCode) {
      401 => message != null ? UnauthorizedFailure(message) : const UnauthorizedFailure(),
      400 || 422 => ValidationFailure(message ?? 'Please check the details and try again'),
      409 => message != null ? ConflictFailure(message) : const ConflictFailure(),
      final code => ServerFailure(message ?? 'Something went wrong on our side', code),
    },
    _ => const UnexpectedFailure(),
  };
}

String? _serverMessage(Object? body) {
  if (body is Map<String, dynamic>) {
    final error = body['error'];
    if (error is Map<String, dynamic>) return error['message'] as String?;
  }
  return null;
}
