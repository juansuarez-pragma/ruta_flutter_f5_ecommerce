import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/auth.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUpAll(() {
    // Registrar fallback values para mocktail
    registerFallbackValue(const UserModel(
      id: 0,
      email: 'fallback@test.com',
      username: 'fallback',
      firstName: 'Fallback',
      lastName: 'User',
    ));
  });

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tEmail = UserFixtures.validEmail;
  const tPassword = UserFixtures.validPassword;
  const tUserModel = UserModel(
    id: 1,
    email: tEmail,
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'valid_token',
  );

  group('login', () {
    test('should return User when login is successful', () async {
      // Arrange
      when(() => mockLocalDataSource.loginUser(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheCurrentUser(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return Right'),
        (user) {
          expect(user.email, tEmail);
          expect(user.token, isNotNull);
        },
      );
      verify(() => mockLocalDataSource.loginUser(email: tEmail, password: tPassword))
          .called(1);
      verify(() => mockLocalDataSource.cacheCurrentUser(tUserModel)).called(1);
    });

    test('should return AuthFailure when credentials are invalid', () async {
      // Arrange
      when(() => mockLocalDataSource.loginUser(email: tEmail, password: 'wrong'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.login(email: tEmail, password: 'wrong');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.type, AuthFailureType.invalidCredentials),
        (r) => fail('Should return Left'),
      );
    });

    test('should return AuthFailure when email is invalid', () async {
      // Act
      final result = await repository.login(email: 'invalid', password: tPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.type, AuthFailureType.invalidEmail),
        (r) => fail('Should return Left'),
      );
    });
  });

  group('register', () {
    test('should return User when registration is successful', () async {
      // Arrange
      when(() => mockLocalDataSource.registerUser(
        email: any(named: 'email'),
        password: any(named: 'password'),
        username: any(named: 'username'),
        firstName: any(named: 'firstName'),
        lastName: any(named: 'lastName'),
      )).thenAnswer((_) async => tUserModel);
      when(() => mockLocalDataSource.cacheCurrentUser(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.register(
        email: tEmail,
        password: tPassword,
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(result.isRight(), true);
    });

    test('should return AuthFailure when email is already in use', () async {
      // Arrange
      when(() => mockLocalDataSource.registerUser(
        email: any(named: 'email'),
        password: any(named: 'password'),
        username: any(named: 'username'),
        firstName: any(named: 'firstName'),
        lastName: any(named: 'lastName'),
      )).thenThrow(const AuthLocalException('Email already registered'));

      // Act
      final result = await repository.register(
        email: tEmail,
        password: tPassword,
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.type, AuthFailureType.emailAlreadyInUse),
        (r) => fail('Should return Left'),
      );
    });

    test('should return AuthFailure when password is weak', () async {
      // Act
      final result = await repository.register(
        email: tEmail,
        password: '123', // Less than 6 characters
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.type, AuthFailureType.weakPassword),
        (r) => fail('Should return Left'),
      );
    });

    test('should return AuthFailure when email is invalid', () async {
      // Act
      final result = await repository.register(
        email: 'invalid-email',
        password: tPassword,
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.type, AuthFailureType.invalidEmail),
        (r) => fail('Should return Left'),
      );
    });
  });

  group('logout', () {
    test('should return void when logout is successful', () async {
      // Arrange
      when(() => mockLocalDataSource.clearCurrentUser())
          .thenAnswer((_) async {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.clearCurrentUser()).called(1);
    });

    test('should return AuthFailure when logout fails', () async {
      // Arrange
      when(() => mockLocalDataSource.clearCurrentUser())
          .thenThrow(Exception('Storage error'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('getCurrentUser', () {
    test('should return User when there is a cached user', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return Right'),
        (user) => expect(user.email, tEmail),
      );
    });

    test('should return AuthFailure when no user is cached', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.type, AuthFailureType.userNotFound),
        (r) => fail('Should return Left'),
      );
    });
  });

  group('isAuthenticated', () {
    test('should return true when user is authenticated', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, true);
    });

    test('should return false when no user is cached', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, false);
    });

    test('should return false when user has no token', () async {
      // Arrange
      const userWithoutToken = UserModel(
        id: 1,
        email: tEmail,
        username: 'testuser',
        firstName: 'Test',
        lastName: 'User',
      );
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => userWithoutToken);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, false);
    });
  });
}
