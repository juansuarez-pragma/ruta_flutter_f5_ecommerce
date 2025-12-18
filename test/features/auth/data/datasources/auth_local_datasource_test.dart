import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_storage_keys.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl authDataSource;
  late MockSharedPreferences mockSharedPreferences;

  const testUserModel = UserModel(
    id: 1,
    email: 'test@example.com',
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'test_token',
  );

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    authDataSource = AuthLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('AuthLocalDataSource - getCachedUser', () {
    test('debe retornar usuario si JSON es válido', () async {
      // Arrange
      final userJson = json.encode(testUserModel.toJson());
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn(userJson);

      // Act
      final result = await authDataSource.getCachedUser();

      // Assert
      expect(result, equals(testUserModel));
    });

    test('debe retornar null si no existe usuario almacenado', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn(null);

      // Act
      final result = await authDataSource.getCachedUser();

      // Assert
      expect(result, isNull);
    });

    test('debe loguear y relanzar ParseException si JSON es inválido', () async {
      // Arrange - JSON mal formado
      const invalidJson = '{"invalid: json}';
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn(invalidJson);

      // Act & Assert
      expect(
        () => authDataSource.getCachedUser(),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe incluir el valor fallido en la excepción', () async {
      // Arrange
      const failedJson = 'invalid json string';
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn(failedJson);

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
    test('debe retornar lista vacía si no existen usuarios', () async {
      // Arrange
      when(
        () => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers),
      ).thenReturn(null);

      // Act
      final result = await authDataSource.isEmailRegistered('test@test.com');

      // Assert
      expect(result, isFalse);
    });

    test('debe loguear si JSON de usuarios es inválido', () async {
      // Arrange - JSON mal formado en registeredUsers
      const invalidJson = '{"invalid: array}';
      when(
        () => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers),
      ).thenReturn(invalidJson);

      // Act & Assert
      expect(
        () => authDataSource.isEmailRegistered('test@test.com'),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe loguear FormatException en parseo de usuarios', () async {
      // Arrange - JSON con estructura inválida
      final invalidUsersList = json.encode(['not_a_map', 'string']);
      when(
        () => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers),
      ).thenReturn(invalidUsersList);

      // Act & Assert
      expect(
        () => authDataSource.loginUser(
          email: 'test@test.com',
          password: 'password',
        ),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe manejar JSON array vacío correctamente', () async {
      // Arrange
      final emptyArray = json.encode(<Map<String, dynamic>>[]);
      when(
        () => mockSharedPreferences.getString(AuthStorageKeys.registeredUsers),
      ).thenReturn(emptyArray);

      // Act
      final result = await authDataSource.isEmailRegistered('test@test.com');

      // Assert
      expect(result, isFalse);
    });
  });

  group('AuthLocalDataSource - cacheCurrentUser', () {
    test('debe guardar usuario en SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(
            AuthStorageKeys.currentUser,
            any(),
          )).thenAnswer((_) async => true);

      // Act
      await authDataSource.cacheCurrentUser(testUserModel);

      // Assert
      verify(() => mockSharedPreferences.setString(
            AuthStorageKeys.currentUser,
            any(),
          )).called(1);
    });
  });

  group('AuthLocalDataSource - clearCurrentUser', () {
    test('debe remover usuario del almacenamiento', () async {
      // Arrange
      when(() => mockSharedPreferences.remove(AuthStorageKeys.currentUser))
          .thenAnswer((_) async => true);

      // Act
      await authDataSource.clearCurrentUser();

      // Assert
      verify(() => mockSharedPreferences.remove(AuthStorageKeys.currentUser))
          .called(1);
    });
  });

  group('AuthLocalDataSource - Error Handling Integration', () {
    test('debe manejar JSON corrupto en getCachedUser y loguear', () async {
      // Arrange
      const corruptedJson = '{"field": invalid}';
      when(() => mockSharedPreferences.getString(AuthStorageKeys.currentUser))
          .thenReturn(corruptedJson);

      // Act & Assert
      expect(
        () => authDataSource.getCachedUser(),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe manejar JSON corrupto en registeredUsers y loguear', () async {
      // Arrange
      const corruptedJson = '[{invalid}]';
      when(() => mockSharedPreferences.getString(
            AuthStorageKeys.registeredUsers,
          )).thenReturn(corruptedJson);

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
}
