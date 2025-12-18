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
    test('debe retornar Left con AuthFailure si ParseException del datasource',
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

    test('debe retornar Left con AuthFailure si UnknownException del datasource',
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

    test('debe manejar ParseException en login', () async {
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

    test('debe manejar ParseException en register', () async {
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

    test('debe manejar excepción en logout', () async {
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

    test('debe capturar AuthLocalException correctamente', () async {
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

    test('debe retornar Right si login exitoso', () async {
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

    test('debe retornar Right si register exitoso', () async {
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

    test('debe retornar Right si logout exitoso', () async {
      // Arrange
      when(() => mockLocalDataSource.clearCurrentUser())
          .thenAnswer((_) async => {});

      // Act
      final result = await authRepository.logout();

      // Assert
      expect(result.isRight(), isTrue);
    });

    test('debe retornar Right si getCurrentUser exitoso', () async {
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
    test('debe retornar true si usuario autenticado existe', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => testUser);

      // Act
      final result = await authRepository.isAuthenticated();

      // Assert
      expect(result, isTrue);
    });

    test('debe retornar false si no hay usuario', () async {
      // Arrange
      when(() => mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await authRepository.isAuthenticated();

      // Assert
      expect(result, isFalse);
    });

    test('debe manejar excepción en isAuthenticated', () async {
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
    test('debe retornar Left con invalidEmail si email es inválido en login',
        () async {
      // Act
      final result = await authRepository.login(
        email: 'invalid-email',
        password: 'password123',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('debe retornar Left con weakPassword si password es corta en register',
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
