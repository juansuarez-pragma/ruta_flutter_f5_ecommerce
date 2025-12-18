import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

  const testUser = User(
    id: 1,
    email: 'test@example.com',
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'test_token',
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();

    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc - Error Handling', () {
    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthLoading, AuthError] cuando login falla',
      build: () {
        when(() => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => Left(AuthFailure.invalidCredentials()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'wrong_password',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>()
            .having((s) => s.message, 'message', isNotEmpty),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthLoading, AuthError] cuando register falla',
      build: () {
        when(() => mockRegisterUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
        )).thenAnswer((_) async => Left(AuthFailure.emailAlreadyInUse()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthRegisterRequested(
        email: 'existing@example.com',
        password: 'password123',
        username: 'user',
        firstName: 'Test',
        lastName: 'User',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>()
            .having((s) => s.message, 'message', isNotEmpty),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthLoading, AuthError] cuando logout falla',
      build: () {
        when(() => mockLogoutUseCase())
            .thenAnswer((_) async => Left(AuthFailure.unknown('Logout failed')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>()
            .having((s) => s.message, 'message', contains('Logout failed')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthUnauthenticated] cuando getCurrentUser falla',
      build: () {
        when(() => mockGetCurrentUserUseCase())
            .thenAnswer((_) async => Left(AuthFailure.userNotFound()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debe incluir failureType en AuthError',
      build: () {
        when(() => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => Left(AuthFailure.invalidEmail()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'invalid-email',
        password: 'password',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>()
            .having((s) => s.failureType, 'failureType', isNotNull),
      ],
    );
  });

  group('AuthBloc - Success Cases', () {
    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthLoading, AuthAuthenticated] cuando login exitoso',
      build: () {
        when(() => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthLoading, AuthAuthenticated] cuando register exitoso',
      build: () {
        when(() => mockRegisterUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
        )).thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthRegisterRequested(
        email: 'new@example.com',
        password: 'password123',
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthLoading, AuthUnauthenticated] cuando logout exitoso',
      build: () {
        when(() => mockLogoutUseCase())
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debe emitir [AuthLoading, AuthAuthenticated] cuando getCurrentUser exitoso',
      build: () {
        when(() => mockGetCurrentUserUseCase())
            .thenAnswer((_) async => const Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: testUser),
      ],
    );
  });

  group('AuthBloc - Estado Inicial', () {
    test('estado inicial debe ser AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });
  });
}
