import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  const tUserModel = UserModel(
    id: 1,
    email: 'test@example.com',
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'valid_token',
  );

  group('cacheCurrentUser', () {
    test('should call SharedPreferences to cache the user', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.cacheCurrentUser(tUserModel);

      // Assert
      final expectedJson = json.encode(tUserModel.toJson());
      verify(() => mockSharedPreferences.setString(
        AuthStorageKeys.currentUser,
        expectedJson,
      )).called(1);
    });
  });

  group('getCachedUser', () {
    test('should return UserModel when there is cached data', () async {
      // Arrange
      final userJson = json.encode(tUserModel.toJson());
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn(userJson);

      // Act
      final result = await dataSource.getCachedUser();

      // Assert
      expect(result, isNotNull);
      expect(result!.id, tUserModel.id);
      expect(result.email, tUserModel.email);
    });

    test('should return null when there is no cached data', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn(null);

      // Act
      final result = await dataSource.getCachedUser();

      // Assert
      expect(result, isNull);
    });

    test('should return null when cached data is invalid JSON', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn('invalid json');

      // Act
      final result = await dataSource.getCachedUser();

      // Assert
      expect(result, isNull);
    });
  });

  group('clearCurrentUser', () {
    test('should call SharedPreferences to remove cached user', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(any()))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.clearCurrentUser();

      // Assert
      verify(() => mockSharedPreferences.remove(AuthStorageKeys.currentUser))
          .called(1);
    });
  });

  group('registerUser', () {
    test('should register a new user and return UserModel with token', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(null);
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await dataSource.registerUser(
        email: 'new@example.com',
        password: 'password123',
        username: 'newuser',
        firstName: 'New',
        lastName: 'User',
      );

      // Assert
      expect(result.email, 'new@example.com');
      expect(result.username, 'newuser');
      expect(result.firstName, 'New');
      expect(result.lastName, 'User');
      expect(result.token, isNotNull);
      expect(result.id, 1);
    });

    test('should throw AuthLocalException when email is already registered', () async {
      // Arrange
      final existingUsers = [
        {
          'user': tUserModel.toJson(),
          'password': base64.encode(utf8.encode('password')),
        }
      ];
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(json.encode(existingUsers));

      // Act & Assert
      expect(
        () => dataSource.registerUser(
          email: tUserModel.email,
          password: 'password123',
          username: 'newuser',
          firstName: 'New',
          lastName: 'User',
        ),
        throwsA(isA<AuthLocalException>()),
      );
    });

    test('should increment ID for new users', () async {
      // Arrange
      final existingUsers = [
        {
          'user': tUserModel.toJson(),
          'password': base64.encode(utf8.encode('password')),
        }
      ];
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(json.encode(existingUsers));
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await dataSource.registerUser(
        email: 'another@example.com',
        password: 'password123',
        username: 'another',
        firstName: 'Another',
        lastName: 'User',
      );

      // Assert
      expect(result.id, 2);
    });
  });

  group('loginUser', () {
    test('should return UserModel when credentials are valid', () async {
      // Arrange
      const password = 'password123';
      final hashedPassword = base64.encode(utf8.encode(password));
      final existingUsers = [
        {
          'user': tUserModel.toJson(),
          'password': hashedPassword,
        }
      ];
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(json.encode(existingUsers));

      // Act
      final result = await dataSource.loginUser(
        email: tUserModel.email,
        password: password,
      );

      // Assert
      expect(result, isNotNull);
      expect(result!.email, tUserModel.email);
      expect(result.token, isNotNull);
    });

    test('should return null when credentials are invalid', () async {
      // Arrange
      final hashedPassword = base64.encode(utf8.encode('password123'));
      final existingUsers = [
        {
          'user': tUserModel.toJson(),
          'password': hashedPassword,
        }
      ];
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(json.encode(existingUsers));

      // Act
      final result = await dataSource.loginUser(
        email: tUserModel.email,
        password: 'wrongpassword',
      );

      // Assert
      expect(result, isNull);
    });

    test('should return null when user does not exist', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(null);

      // Act
      final result = await dataSource.loginUser(
        email: 'nonexistent@example.com',
        password: 'password123',
      );

      // Assert
      expect(result, isNull);
    });
  });

  group('isEmailRegistered', () {
    test('should return true when email exists', () async {
      // Arrange
      final existingUsers = [
        {
          'user': tUserModel.toJson(),
          'password': 'hashed',
        }
      ];
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(json.encode(existingUsers));

      // Act
      final result = await dataSource.isEmailRegistered(tUserModel.email);

      // Assert
      expect(result, true);
    });

    test('should return false when email does not exist', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers))
          .thenReturn(null);

      // Act
      final result = await dataSource.isEmailRegistered('new@example.com');

      // Assert
      expect(result, false);
    });
  });
}
