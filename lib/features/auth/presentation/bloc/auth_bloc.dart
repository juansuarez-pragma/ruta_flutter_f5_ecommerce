import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/get_current_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC para gestión de autenticación.
///
/// Maneja login, registro, logout y verificación de sesión.
class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  /// Verifica si hay una sesión activa al iniciar la app.
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Maneja el inicio de sesión.
  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        failureType: failure.type,
      )),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Maneja el registro de nuevo usuario.
  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      username: event.username,
      firstName: event.firstName,
      lastName: event.lastName,
    );

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        failureType: failure.type,
      )),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Maneja el cierre de sesión.
  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        failureType: failure.type,
      )),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
