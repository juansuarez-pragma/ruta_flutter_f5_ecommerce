import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/auth.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;

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

  const tUser = UserFixtures.sampleUser;
  const tEmail = UserFixtures.validEmail;
  const tPassword = UserFixtures.validPassword;

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when user is logged in',
      build: () {
        when(() => mockGetCurrentUserUseCase())
            .thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: tUser),
      ],
      verify: (_) {
        verify(() => mockGetCurrentUserUseCase()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when no user is logged in',
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
  });

  group('AuthLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(() => mockLoginUseCase(email: tEmail, password: tPassword))
            .thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: tUser),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(email: tEmail, password: tPassword))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails with invalid credentials',
      build: () {
        when(() => mockLoginUseCase(email: tEmail, password: 'wrong'))
            .thenAnswer((_) async => Left(AuthFailure.invalidCredentials()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: tEmail,
        password: 'wrong',
      )),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: AuthFailure.invalidCredentials().message,
          failureType: AuthFailureType.invalidCredentials,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails with connection error',
      build: () {
        when(() => mockLoginUseCase(email: tEmail, password: tPassword))
            .thenAnswer((_) async => Left(AuthFailure.connectionError()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: AuthFailure.connectionError().message,
          failureType: AuthFailureType.connectionError,
        ),
      ],
    );
  });

  group('AuthRegisterRequested', () {
    const tUsername = 'newuser';
    const tFirstName = 'New';
    const tLastName = 'User';

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when registration succeeds',
      build: () {
        when(() => mockRegisterUseCase(
          email: tEmail,
          password: tPassword,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        )).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthRegisterRequested(
        email: tEmail,
        password: tPassword,
        username: tUsername,
        firstName: tFirstName,
        lastName: tLastName,
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when email is already in use',
      build: () {
        when(() => mockRegisterUseCase(
          email: tEmail,
          password: tPassword,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        )).thenAnswer((_) async => Left(AuthFailure.emailAlreadyInUse()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthRegisterRequested(
        email: tEmail,
        password: tPassword,
        username: tUsername,
        firstName: tFirstName,
        lastName: tLastName,
      )),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: AuthFailure.emailAlreadyInUse().message,
          failureType: AuthFailureType.emailAlreadyInUse,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when password is weak',
      build: () {
        when(() => mockRegisterUseCase(
          email: tEmail,
          password: '123',
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        )).thenAnswer((_) async => Left(AuthFailure.weakPassword()));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthRegisterRequested(
        email: tEmail,
        password: '123',
        username: tUsername,
        firstName: tFirstName,
        lastName: tLastName,
      )),
      expect: () => [
        const AuthLoading(),
        AuthError(
          message: AuthFailure.weakPassword().message,
          failureType: AuthFailureType.weakPassword,
        ),
      ],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
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
      verify: (_) {
        verify(() => mockLogoutUseCase()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when logout fails',
      build: () {
        when(() => mockLogoutUseCase())
            .thenAnswer((_) async => Left(AuthFailure.unknown('Error')));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthError(
          message: 'Error',
          failureType: AuthFailureType.unknown,
        ),
      ],
    );
  });
}
