import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/features/auth/auth.dart';

void main() {
  group('User Entity', () {
    const tUser = User(
      id: 1,
      email: 'test@example.com',
      username: 'testuser',
      firstName: 'Test',
      lastName: 'User',
      token: 'valid_token_123',
    );

    const tUserWithoutToken = User(
      id: 2,
      email: 'notoken@example.com',
      username: 'notoken',
      firstName: 'No',
      lastName: 'Token',
    );

    test('should return correct fullName', () {
      // Act
      final result = tUser.fullName;

      // Assert
      expect(result, 'Test User');
    });

    test('should return true for isAuthenticated when token exists', () {
      // Act
      final result = tUser.isAuthenticated;

      // Assert
      expect(result, true);
    });

    test('should return false for isAuthenticated when token is null', () {
      // Act
      final result = tUserWithoutToken.isAuthenticated;

      // Assert
      expect(result, false);
    });

    test('should return false for isAuthenticated when token is empty', () {
      // Arrange
      const userWithEmptyToken = User(
        id: 3,
        email: 'empty@example.com',
        username: 'empty',
        firstName: 'Empty',
        lastName: 'Token',
        token: '',
      );

      // Act
      final result = userWithEmptyToken.isAuthenticated;

      // Assert
      expect(result, false);
    });

    test('copyWith should create a copy with updated fields', () {
      // Act
      final result = tUser.copyWith(email: 'newemail@example.com');

      // Assert
      expect(result.id, tUser.id);
      expect(result.email, 'newemail@example.com');
      expect(result.username, tUser.username);
      expect(result.firstName, tUser.firstName);
      expect(result.lastName, tUser.lastName);
      expect(result.token, tUser.token);
    });

    test('copyWith with no parameters should return identical user', () {
      // Act
      final result = tUser.copyWith();

      // Assert
      expect(result, tUser);
    });

    test('two users with same properties should be equal (Equatable)', () {
      // Arrange
      const user1 = User(
        id: 1,
        email: 'same@example.com',
        username: 'same',
        firstName: 'Same',
        lastName: 'User',
      );

      const user2 = User(
        id: 1,
        email: 'same@example.com',
        username: 'same',
        firstName: 'Same',
        lastName: 'User',
      );

      // Assert
      expect(user1, user2);
    });

    test('two users with different properties should not be equal', () {
      // Arrange
      const user1 = User(
        id: 1,
        email: 'user1@example.com',
        username: 'user1',
        firstName: 'User',
        lastName: 'One',
      );

      const user2 = User(
        id: 2,
        email: 'user2@example.com',
        username: 'user2',
        firstName: 'User',
        lastName: 'Two',
      );

      // Assert
      expect(user1, isNot(user2));
    });

    test('props should contain all properties', () {
      // Act
      final props = tUser.props;

      // Assert
      expect(props, [
        tUser.id,
        tUser.email,
        tUser.username,
        tUser.firstName,
        tUser.lastName,
        tUser.token,
      ]);
    });
  });
}
