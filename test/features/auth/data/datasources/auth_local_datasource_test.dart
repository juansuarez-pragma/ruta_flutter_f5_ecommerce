import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/app_logger.dart';
import 'package:ecommerce/core/storage/secure_key_value_store.dart';
import 'package:ecommerce/core/utils/id_generator.dart';
import 'package:ecommerce/features/auth/data/errors/auth_local_exception.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_storage_keys.dart';
import 'package:ecommerce/features/auth/data/security/password_hasher.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAppLogger extends Mock implements AppLogger {}

class MockSecureKeyValueStore extends Mock implements SecureKeyValueStore {}

class MockPasswordHasher extends Mock implements PasswordHasher {}

class MockIdGenerator extends Mock implements IdGenerator {}

void main() {
  late AuthLocalDataSourceImpl authDataSource;
  late MockSharedPreferences mockLegacySharedPreferences;
  late MockSecureKeyValueStore mockSecureStore;
  late MockAppLogger mockLogger;
  late MockPasswordHasher mockPasswordHasher;
  late MockIdGenerator mockTokenGenerator;

  setUpAll(() {
    registerFallbackValue(
      const PasswordHash(
        algorithm: 'TEST',
        iterations: 1,
        saltBase64: 'c2FsdA==',
        hashBase64: 'aGFzaA==',
      ),
    );
  });

  const testUserModel = UserModel(
    id: 1,
    email: 'test@example.com',
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'test_token',
  );

  setUp(() {
    mockLegacySharedPreferences = MockSharedPreferences();
    mockSecureStore = MockSecureKeyValueStore();
    mockLogger = MockAppLogger();
    mockPasswordHasher = MockPasswordHasher();
    mockTokenGenerator = MockIdGenerator();

    // Default: no legacy values to migrate.
    when(() => mockLegacySharedPreferences.getString(any())).thenReturn(null);

    authDataSource = AuthLocalDataSourceImpl(
      legacySharedPreferences: mockLegacySharedPreferences,
      secureStore: mockSecureStore,
      passwordHasher: mockPasswordHasher,
      tokenGenerator: mockTokenGenerator,
      logger: mockLogger,
    );
  });

  group('AuthLocalDataSource - getCachedUser', () {
    test('should return a user when JSON is valid', () async {
      // Arrange
      final userJson = json.encode(testUserModel.toJson());
      when(() => mockSecureStore.read(AuthStorageKeys.currentUser))
          .thenAnswer((_) async => userJson);

      // Act
      final result = await authDataSource.getCachedUser();

      // Assert
      expect(result, equals(testUserModel));
    });

    test('should return null when there is no cached user', () async {
      // Arrange
      when(() => mockSecureStore.read(AuthStorageKeys.currentUser))
          .thenAnswer((_) async => null);

      // Act
      final result = await authDataSource.getCachedUser();

      // Assert
      expect(result, isNull);
    });

    test('should rethrow ParseException when JSON is invalid', () async {
      // Arrange - malformed JSON
      const invalidJson = '{"invalid: json}';
      when(() => mockSecureStore.read(AuthStorageKeys.currentUser))
          .thenAnswer((_) async => invalidJson);

      // Act & Assert
      expect(
        () => authDataSource.getCachedUser(),
        throwsA(isA<ParseException>()),
      );
    });

    test('should include the failed value in the exception', () async {
      // Arrange
      const failedJson = 'invalid json string';
      when(() => mockSecureStore.read(AuthStorageKeys.currentUser))
          .thenAnswer((_) async => failedJson);

      // Act & Assert
      expect(
        () => authDataSource.getCachedUser(),
        throwsA(
          isA<ParseException>().having(
            (e) => e.failedValue,
            'failedValue',
            contains('invalid'),
          ),
        ),
      );
    });
  });

  group('AuthLocalDataSource - _getRegisteredUsersWithPasswords', () {
    test('should return an empty list when there are no users', () async {
      // Arrange
      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => null);

      // Act
      final result = await authDataSource.isEmailRegistered('test@test.com');

      // Assert
      expect(result, isFalse);
    });

    test('should rethrow when registeredUsers JSON is invalid', () async {
      // Arrange - malformed JSON in registeredUsers
      const invalidJson = '{"invalid: array}';
      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => invalidJson);

      // Act & Assert
      expect(
        () => authDataSource.isEmailRegistered('test@test.com'),
        throwsA(isA<ParseException>()),
      );
    });

    test('should throw ParseException when users list cannot be parsed', () async {
      // Arrange - JSON with invalid structure
      final invalidUsersList = json.encode(['not_a_map', 'string']);
      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => invalidUsersList);

      // Act & Assert
      expect(
        () => authDataSource.loginUser(
          email: 'test@test.com',
          password: 'password',
        ),
        throwsA(isA<ParseException>()),
      );
    });

    test('should handle an empty JSON array correctly', () async {
      // Arrange
      final emptyArray = json.encode(<Map<String, dynamic>>[]);
      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => emptyArray);

      // Act
      final result = await authDataSource.isEmailRegistered('test@test.com');

      // Assert
      expect(result, isFalse);
    });
  });

  group('AuthLocalDataSource - cacheCurrentUser', () {
    test('should persist the user in SharedPreferences', () async {
      // Arrange
      when(() => mockSecureStore.write(AuthStorageKeys.currentUser, any()))
          .thenAnswer((_) async {});

      // Act
      await authDataSource.cacheCurrentUser(testUserModel);

      // Assert
      verify(() => mockSecureStore.write(AuthStorageKeys.currentUser, any()))
          .called(1);
    });
  });

  group('AuthLocalDataSource - clearCurrentUser', () {
    test('should remove the user from storage', () async {
      // Arrange
      when(() => mockSecureStore.delete(AuthStorageKeys.currentUser))
          .thenAnswer((_) async {});

      // Act
      await authDataSource.clearCurrentUser();

      // Assert
      verify(() => mockSecureStore.delete(AuthStorageKeys.currentUser)).called(1);
    });
  });

  group('AuthLocalDataSource - Error Handling Integration', () {
    test('should throw on corrupted JSON in getCachedUser', () async {
      // Arrange
      const corruptedJson = '{"field": invalid}';
      when(() => mockSecureStore.read(AuthStorageKeys.currentUser))
          .thenAnswer((_) async => corruptedJson);

      // Act & Assert
      expect(
        () => authDataSource.getCachedUser(),
        throwsA(isA<ParseException>()),
      );
    });

    test('should throw on corrupted JSON in registeredUsers', () async {
      // Arrange
      const corruptedJson = '[{invalid}]';
      when(() => mockSecureStore.read(AuthStorageKeys.registeredUsers))
          .thenAnswer((_) async => corruptedJson);

      // Act & Assert
      expect(
        () => authDataSource.loginUser(
          email: 'test@test.com',
          password: 'password',
        ),
        throwsA(isA<ParseException>()),
      );
    });
  });

  group('AuthLocalDataSource - registerUser', () {
    test('should assign id 1 when there are no registered users', () async {
      // Arrange
      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => null);

      when(
        () => mockSecureStore.write(AuthStorageKeys.registeredUsers, any()),
      ).thenAnswer((_) async {});

      when(() => mockTokenGenerator.generate()).thenReturn('token-1');
      when(() => mockPasswordHasher.hash(any())).thenAnswer(
        (_) async => const PasswordHash(
          algorithm: 'TEST',
          iterations: 1,
          saltBase64: 'c2FsdA==',
          hashBase64: 'aGFzaA==',
        ),
      );

      // Act
      final user = await authDataSource.registerUser(
        email: 'new@example.com',
        password: 'password123',
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(user.id, 1);
      expect(user.email, 'new@example.com');
      verify(
        () => mockSecureStore.write(AuthStorageKeys.registeredUsers, any()),
      ).called(1);
    });

    test('should assign next id based on max existing id', () async {
      // Arrange: existing users with ids 3 and 10 -> next should be 11.
      final existing = [
        {
          'user': const UserModel(
            id: 3,
            email: 'a@example.com',
            username: 'a',
            firstName: 'A',
            lastName: 'A',
          ).toJson(),
          'passwordHash': const PasswordHash(
            algorithm: 'TEST',
            iterations: 1,
            saltBase64: 'c2FsdA==',
            hashBase64: 'aGFzaA==',
          ).toJson(),
        },
        {
          'user': const UserModel(
            id: 10,
            email: 'b@example.com',
            username: 'b',
            firstName: 'B',
            lastName: 'B',
          ).toJson(),
          'passwordHash': const PasswordHash(
            algorithm: 'TEST',
            iterations: 1,
            saltBase64: 'c2FsdA==',
            hashBase64: 'aGFzaA==',
          ).toJson(),
        },
      ];

      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => json.encode(existing));

      when(
        () => mockSecureStore.write(AuthStorageKeys.registeredUsers, any()),
      ).thenAnswer((_) async {});

      when(() => mockTokenGenerator.generate()).thenReturn('token-2');
      when(() => mockPasswordHasher.hash(any())).thenAnswer(
        (_) async => const PasswordHash(
          algorithm: 'TEST',
          iterations: 1,
          saltBase64: 'c2FsdA==',
          hashBase64: 'aGFzaA==',
        ),
      );

      // Act
      final user = await authDataSource.registerUser(
        email: 'new@example.com',
        password: 'password123',
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(user.id, 11);
    });

    test('should throw AuthLocalException when email is already registered',
        () async {
      // Arrange: existing user with same email.
      final existing = [
        {
          'user': const UserModel(
            id: 1,
            email: 'dup@example.com',
            username: 'dup',
            firstName: 'Dup',
            lastName: 'User',
          ).toJson(),
          'passwordHash': const PasswordHash(
            algorithm: 'TEST',
            iterations: 1,
            saltBase64: 'c2FsdA==',
            hashBase64: 'aGFzaA==',
          ).toJson(),
        },
      ];

      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => json.encode(existing));

      // Act & Assert
      expect(
        () => authDataSource.registerUser(
          email: 'dup@example.com',
          password: 'password123',
          username: 'newuser',
          firstName: 'New',
          lastName: 'User',
        ),
        throwsA(isA<AuthLocalException>()),
      );
    });

    test('should persist the new user record with password and user json',
        () async {
      // Arrange
      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => null);

      when(
        () => mockSecureStore.write(AuthStorageKeys.registeredUsers, any()),
      ).thenAnswer((_) async {});

      when(() => mockTokenGenerator.generate()).thenReturn('token-3');
      when(() => mockPasswordHasher.hash(any())).thenAnswer(
        (_) async => const PasswordHash(
          algorithm: 'TEST',
          iterations: 1,
          saltBase64: 'c2FsdA==',
          hashBase64: 'aGFzaA==',
        ),
      );

      // Act
      final created = await authDataSource.registerUser(
        email: 'new@example.com',
        password: 'password123',
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert: inspect what was persisted.
      final captured = verify(
        () => mockSecureStore.write(AuthStorageKeys.registeredUsers, captureAny()),
      ).captured.single as String;

      final decoded = json.decode(captured) as List<dynamic>;
      expect(decoded, hasLength(1));

      final record = decoded.first as Map<String, dynamic>;
      expect(record.keys, containsAll(['user', 'passwordHash']));

      final userJson = record['user'] as Map<String, dynamic>;
      expect(userJson['id'], created.id);
      expect(userJson['email'], 'new@example.com');
      expect(record['passwordHash'], isA<Map<String, dynamic>>());
    });
  });

  group('AuthLocalDataSource - loginUser', () {
    test('should return null when no user matches the credentials', () async {
      // Arrange: no users in storage.
      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => null);

      // Act
      final user = await authDataSource.loginUser(
        email: 'missing@example.com',
        password: 'password123',
      );

      // Assert
      expect(user, isNull);
    });

    test('should return user with a refreshed token when credentials match',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      const storedUser = UserModel(
        id: 1,
        email: email,
        username: 'testuser',
        firstName: 'Test',
        lastName: 'User',
      );

      final storedRecords = [
        {
          'user': storedUser.toJson(),
          'passwordHash': const PasswordHash(
            algorithm: 'TEST',
            iterations: 1,
            saltBase64: 'c2FsdA==',
            hashBase64: 'aGFzaA==',
          ).toJson(),
        },
      ];

      when(
        () => mockSecureStore.read(AuthStorageKeys.registeredUsers),
      ).thenAnswer((_) async => json.encode(storedRecords));

      when(() => mockPasswordHasher.verify(password, any()))
          .thenAnswer((_) async => true);
      when(() => mockTokenGenerator.generate()).thenReturn('token-4');

      // Act
      final user = await authDataSource.loginUser(
        email: email,
        password: password,
      );

      // Assert
      expect(user, isNotNull);
      expect(user!.email, email);
      expect(user.token, 'token-4');
    });
  });
}
