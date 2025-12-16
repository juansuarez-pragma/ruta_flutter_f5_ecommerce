import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/features/auth/auth.dart';
import '../../../../helpers/mocks.dart';

void main() {
  group('UserModel', () {
    const tUserModel = UserModel(
      id: 1,
      email: 'test@example.com',
      username: 'testuser',
      firstName: 'Test',
      lastName: 'User',
      token: 'valid_token_abc123',
    );

    final tUserJson = {
      'id': 1,
      'email': 'test@example.com',
      'username': 'testuser',
      'firstName': 'Test',
      'lastName': 'User',
      'token': 'valid_token_abc123',
    };

    group('fromJson', () {
      test('should return a valid UserModel from JSON', () {
        // Act
        final result = UserModel.fromJson(tUserJson);

        // Assert
        expect(result, tUserModel);
        expect(result.id, 1);
        expect(result.email, 'test@example.com');
        expect(result.username, 'testuser');
        expect(result.firstName, 'Test');
        expect(result.lastName, 'User');
        expect(result.token, 'valid_token_abc123');
      });

      test('should handle null token in JSON', () {
        // Arrange
        final jsonWithNullToken = {
          'id': 1,
          'email': 'test@example.com',
          'username': 'testuser',
          'firstName': 'Test',
          'lastName': 'User',
          'token': null,
        };

        // Act
        final result = UserModel.fromJson(jsonWithNullToken);

        // Assert
        expect(result.token, isNull);
        expect(result.isAuthenticated, false);
      });

      test('should handle missing token in JSON (defaults to null)', () {
        // Arrange
        final jsonWithoutToken = {
          'id': 1,
          'email': 'test@example.com',
          'username': 'testuser',
          'firstName': 'Test',
          'lastName': 'User',
        };

        // Act
        final result = UserModel.fromJson(jsonWithoutToken);

        // Assert - token is optional and defaults to null
        expect(result.token, isNull);
        expect(result.isAuthenticated, false);
      });
    });

    group('toJson', () {
      test('should return a valid JSON map from UserModel', () {
        // Act
        final result = tUserModel.toJson();

        // Assert
        expect(result, tUserJson);
      });

      test('should include null token in JSON output', () {
        // Arrange
        const userWithoutToken = UserModel(
          id: 1,
          email: 'test@example.com',
          username: 'testuser',
          firstName: 'Test',
          lastName: 'User',
        );

        // Act
        final result = userWithoutToken.toJson();

        // Assert
        expect(result['token'], isNull);
      });
    });

    group('fromEntity', () {
      test('should create UserModel from User entity', () {
        // Arrange
        const user = UserFixtures.sampleUser;

        // Act
        final result = UserModel.fromEntity(user);

        // Assert
        expect(result.id, user.id);
        expect(result.email, user.email);
        expect(result.username, user.username);
        expect(result.firstName, user.firstName);
        expect(result.lastName, user.lastName);
        expect(result.token, user.token);
      });
    });

    group('toEntity', () {
      test('should convert UserModel to User entity', () {
        // Act
        final result = tUserModel.toEntity();

        // Assert
        expect(result, isA<User>());
        expect(result.id, tUserModel.id);
        expect(result.email, tUserModel.email);
        expect(result.username, tUserModel.username);
        expect(result.firstName, tUserModel.firstName);
        expect(result.lastName, tUserModel.lastName);
        expect(result.token, tUserModel.token);
      });
    });

    group('copyWithToken', () {
      test('should create copy with new token', () {
        // Act
        final result = tUserModel.copyWithToken('new_token_xyz');

        // Assert
        expect(result.token, 'new_token_xyz');
        expect(result.id, tUserModel.id);
        expect(result.email, tUserModel.email);
      });

      test('should create copy with null token', () {
        // Act
        final result = tUserModel.copyWithToken(null);

        // Assert
        expect(result.token, isNull);
        expect(result.isAuthenticated, false);
      });
    });

    group('inheritance', () {
      test('UserModel should be a subclass of User', () {
        // Assert
        expect(tUserModel, isA<User>());
      });

      test('UserModel should inherit User methods', () {
        // Assert
        expect(tUserModel.fullName, 'Test User');
        expect(tUserModel.isAuthenticated, true);
      });
    });
  });
}
