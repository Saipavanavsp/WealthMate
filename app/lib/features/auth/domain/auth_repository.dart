import '../../../core/error/result.dart';
import 'entities/session.dart';

abstract interface class AuthRepository {
  /// Loads a saved session from secure storage, if any.
  Future<Session?> restoreSession();

  Future<Result<Session>> login({required String email, required String password});

  Future<Result<Session>> register({required String name, required String email, required String password});

  /// Starts an offline session filled with sample data. Nothing is sent to a server.
  Future<Session> startDemo();

  Future<void> logout();

  /// Emits null when the session ends, including when a token refresh fails.
  Stream<Session?> get sessionChanges;
}

abstract interface class BiometricAuthenticator {
  Future<bool> isAvailable();

  Future<bool> authenticate(String reason);
}
