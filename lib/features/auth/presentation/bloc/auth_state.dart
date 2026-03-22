import 'package:equatable/equatable.dart';
import 'package:stream_xtream/features/auth/domain/entities/user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? savedServerUrl;
  final String? savedUsername;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.savedServerUrl,
    this.savedUsername,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? savedServerUrl,
    String? savedUsername,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      savedServerUrl: savedServerUrl ?? this.savedServerUrl,
      savedUsername: savedUsername ?? this.savedUsername,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, savedServerUrl, savedUsername];
}
