import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/features/auth/data/errors/auth_local_exception.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';
import 'package:ecommerce/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthLocalDataSource mockLocalDataSource;

  const testUser = UserModel(
    id: 1,
    email: 'test@example.com',
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'test_token',
  );

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    authRepository = AuthRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('AuthRepositoryImpl - Error Handling', () {
    test('should return Left(AuthFailure) when datasource throws ParseException',
        () async {
      // Arrange
      const parseException = ParseException(message: 'JSON corrupted');
      when(() => mockLocalDataSource.getCachedUser())
          .thenThrow(parseException);

      // Act
      final result = await authRepository.getCurrentUser();

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Left(AuthFailure) when datasource throws UnknownException',
        () async {
      // Arrange
      const unknownException = UnknownException(
        message: 'Unexpected error',
      );
      when(() => mockLocalDataSource.getCachedUser())
          .thenThrow(unknownException);

      // Act
      final result = await authRepository.getCurrentUser();

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should handle ParseException in login', () async {
      // Arrange
      const parseException = ParseException(message: 'Data corrupted');
      when(
        () => mockLocalDataSource.loginUser(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(parseException);

      // Act
      final result = await authRepository.login(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should handle ParseException in register', () async {
      // Arrange
      const parseException = ParseException(message: 'Storage error');
      when(
        () => mockLocalDataSource.registerUser(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
        ),
      ).thenThrow(parseException);

      // Act
      final result = await authRepository.register(
        email: 'new@example.com',
        password: 'password123',
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should handle exceptions in logout', () async {
      // Arrange
      const unknownException = UnknownException(
        message: 'Could not clear cache',
      );
      when(() => mockLocalDataSource.clearCurrentUser())
          .thenThrow(unknownException);

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should map AuthLocalException correctly', () async {
      // Arrange
      const authException = AuthLocalException('Email already exists');
      when(
        () => mockLocalDataSource.registerUser(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
        ),
      ).thenThrow(authException);

      // Act
      final result = await authRepository.register(
        email: 'existing@example.com',
        password: 'password123',
        username: 'user',
        firstName: 'Test',
        lastName: 'User',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Right when login succeeds', () async {
      // Arrange
      when(
        () => mockLocalDataSource.loginUser(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => testUser);
      when(() => mockLocalDataSource.cacheCurrentUser(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await authRepository.login(
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) => expect(user.email, equals('test@example.com')),
      );
    });

    test('should return Right when register succeeds', () async {
      // Arrange
      when(
        () => mockLocalDataSource.registerUser(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
        ),
      ).thenAnswer((_) async => testUser);
      when(() => mockLocalDataSource.cacheCurrentUser(any()))
          .thenAnswer((_) async => {});

      // Act
      final result = await authRepository.register(
        email: 'new@example.com',
        password: 'password123',
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(result.isRight(), isTrue);
    });

    test('should return Right when logout succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.clearCurrentUser())
          .thenAnswer((_) async => {});

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result.isRight(), isTrue);
    });

    test('should return Right when getCurrentUser succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => testUser);

      // Act
      final result = await authRepository.getCurrentUser();

      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (user) => expect(user.email, equals('test@example.com')),
      );
    });
  });

  group('AuthRepositoryImpl - isAuthenticated', () {
    test('should return true when an authenticated user exists', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => testUser);

      // Act
      final result = await authRepository.isAuthenticated();

      // Assert
      expect(result, isTrue);
    });

    test('should return false when there is no cached user', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await authRepository.isAuthenticated();

      // Assert
      expect(result, isFalse);
    });

    test('should handle exceptions in isAuthenticated', () async {
      // Arrange
      const exception = UnknownException(message: 'Error');
      when(() => mockLocalDataSource.getCachedUser())
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => authRepository.isAuthenticated(),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  group('AuthRepositoryImpl - Validation', () {
    test('should return Left(invalidEmail) when email is invalid in login',
        () async {
      // Act
      final result = await authRepository.login(
        email: 'invalid-email',
        password: 'password123',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Left(weakPassword) when password is too short in register',
        () async {
      // Act
      final result = await authRepository.register(
        email: 'test@example.com',
        password: 'short',
        username: 'user',
        firstName: 'Test',
        lastName: 'User',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });
  });
}
