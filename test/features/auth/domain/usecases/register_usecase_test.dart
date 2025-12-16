import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/auth.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(repository: mockRepository);
  });

  const tEmail = UserFixtures.validEmail;
  const tPassword = UserFixtures.validPassword;
  const tUsername = 'newuser';
  const tFirstName = 'New';
  const tLastName = 'User';
  const tUser = UserFixtures.sampleUser;

  group('RegisterUseCase', () {
    test('should return User when registration is successful', () async {
      // Arrange
      when(
        () => mockRepository.register(
          email: tEmail,
          password: tPassword,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        ),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase(
        email: tEmail,
        password: tPassword,
        username: tUsername,
        firstName: tFirstName,
        lastName: tLastName,
      );

      // Assert
      expect(result, const Right(tUser));
      verify(
        () => mockRepository.register(
          email: tEmail,
          password: tPassword,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when email is already in use', () async {
      // Arrange
      final failure = AuthFailure.emailAlreadyInUse();
      when(
        () => mockRepository.register(
          email: tEmail,
          password: tPassword,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        ),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(
        email: tEmail,
        password: tPassword,
        username: tUsername,
        firstName: tFirstName,
        lastName: tLastName,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, AuthFailureType.emailAlreadyInUse),
        (r) => fail('Should return Left'),
      );
    });

    test('should return AuthFailure when password is weak', () async {
      // Arrange
      final failure = AuthFailure.weakPassword();
      when(
        () => mockRepository.register(
          email: tEmail,
          password: '123',
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        ),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(
        email: tEmail,
        password: '123',
        username: tUsername,
        firstName: tFirstName,
        lastName: tLastName,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, AuthFailureType.weakPassword),
        (r) => fail('Should return Left'),
      );
    });

    test('should return AuthFailure when email is invalid', () async {
      // Arrange
      final failure = AuthFailure.invalidEmail();
      when(
        () => mockRepository.register(
          email: 'invalid-email',
          password: tPassword,
          username: tUsername,
          firstName: tFirstName,
          lastName: tLastName,
        ),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(
        email: 'invalid-email',
        password: tPassword,
        username: tUsername,
        firstName: tFirstName,
        lastName: tLastName,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, AuthFailureType.invalidEmail),
        (r) => fail('Should return Left'),
      );
    });
  });
}
