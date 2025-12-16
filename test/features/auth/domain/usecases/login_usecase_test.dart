import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/auth.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(repository: mockRepository);
  });

  const tEmail = UserFixtures.validEmail;
  const tPassword = UserFixtures.validPassword;
  const tUser = UserFixtures.sampleUser;

  group('LoginUseCase', () {
    test('should return User when login is successful', () async {
      // Arrange
      when(
        () => mockRepository.login(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Right(tUser));
      verify(
        () => mockRepository.login(email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when credentials are invalid', () async {
      // Arrange
      final failure = AuthFailure.invalidCredentials();
      when(
        () => mockRepository.login(email: tEmail, password: 'wrongpassword'),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(email: tEmail, password: 'wrongpassword');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, AuthFailureType.invalidCredentials),
        (r) => fail('Should return Left'),
      );
      verify(
        () => mockRepository.login(email: tEmail, password: 'wrongpassword'),
      ).called(1);
    });

    test('should return AuthFailure when connection fails', () async {
      // Arrange
      final failure = AuthFailure.connectionError();
      when(
        () => mockRepository.login(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(email: tEmail, password: tPassword);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, AuthFailureType.connectionError),
        (r) => fail('Should return Left'),
      );
    });

    test('should pass email and password to repository', () async {
      // Arrange
      when(
        () => mockRepository.login(email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      await useCase(email: 'custom@email.com', password: 'customPassword');

      // Assert
      verify(
        () => mockRepository.login(email: 'custom@email.com', password: 'customPassword'),
      ).called(1);
    });
  });
}
