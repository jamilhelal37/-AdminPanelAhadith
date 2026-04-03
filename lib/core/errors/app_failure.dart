enum FailureType {
  validation,
  notFound,
  unauthorized,
  network,
  storage,
  unknown,
}

class AppFailure implements Exception {
  const AppFailure({
    required this.message,
    this.type = FailureType.unknown,
    this.operation,
    this.details,
    this.cause,
  });

  final String message;
  final FailureType type;
  final String? operation;
  final Object? details;
  final Object? cause;

  factory AppFailure.validation(
    String message, {
    String? operation,
    Object? details,
    Object? cause,
  }) {
    return AppFailure(
      message: message,
      type: FailureType.validation,
      operation: operation,
      details: details,
      cause: cause,
    );
  }

  factory AppFailure.notFound(
    String message, {
    String? operation,
    Object? details,
    Object? cause,
  }) {
    return AppFailure(
      message: message,
      type: FailureType.notFound,
      operation: operation,
      details: details,
      cause: cause,
    );
  }

  factory AppFailure.unauthorized(
    String message, {
    String? operation,
    Object? details,
    Object? cause,
  }) {
    return AppFailure(
      message: message,
      type: FailureType.unauthorized,
      operation: operation,
      details: details,
      cause: cause,
    );
  }

  factory AppFailure.network(
    String message, {
    String? operation,
    Object? details,
    Object? cause,
  }) {
    return AppFailure(
      message: message,
      type: FailureType.network,
      operation: operation,
      details: details,
      cause: cause,
    );
  }

  factory AppFailure.storage(
    String message, {
    String? operation,
    Object? details,
    Object? cause,
  }) {
    return AppFailure(
      message: message,
      type: FailureType.storage,
      operation: operation,
      details: details,
      cause: cause,
    );
  }

  @override
  String toString() => message;
}
