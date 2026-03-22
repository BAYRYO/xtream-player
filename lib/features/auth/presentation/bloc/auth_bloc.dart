import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_xtream/features/auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      // Add timeout to prevent infinite loading
      final isLoggedIn = await _authRepository.isLoggedIn().timeout(
        const Duration(seconds: 5),
        onTimeout: () => false,
      );
      
      if (!isLoggedIn) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }
      
      final savedCredentials = await _authRepository.getSavedCredentials().timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );

      if (savedCredentials == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }

      final user = await _authRepository.getCurrentUser().timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
      
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          savedServerUrl: savedCredentials['serverUrl'],
          savedUsername: savedCredentials['username'],
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          savedServerUrl: savedCredentials['serverUrl'],
          savedUsername: savedCredentials['username'],
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.login(
        event.serverUrl,
        event.username,
        event.password,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        savedServerUrl: event.serverUrl,
        savedUsername: event.username,
      ));
    } catch (e) {
      String errorMessage = e.toString();
      
      // Clean up error messages
      if (errorMessage.contains('Exception:')) {
        errorMessage = errorMessage.replaceAll('Exception: ', '');
      }
      
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
