import 'package:equatable/equatable.dart';

/// Errors that the presentation layer knows how to show. Data sources throw
/// exceptions; repositories catch them and return one of these instead.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'The server took too long to respond']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Your session has expired. Please sign in again.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'This record was changed on another device']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our side', this.statusCode]);

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

final class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Could not read or write local data']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something unexpected happened']);
}
