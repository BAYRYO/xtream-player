abstract class Failure {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure: $message (code: $code)';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred', super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unknown error occurred', super.code});
}
