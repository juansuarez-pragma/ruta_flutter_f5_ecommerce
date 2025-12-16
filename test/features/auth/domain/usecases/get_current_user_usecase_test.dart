import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/auth.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late GetCurrentUserUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetCurrentUserUseCase(repository: mockRepository);
  });

  const tUser = UserFixtures.sampleUser;

  group('GetCurrentUserUseCase', () {
    test('should return User when there is an authenticated session', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when no user is authenticated', () async {
      // Arrange
      final failure = AuthFailure.userNotFound();
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, AuthFailureType.userNotFound),
        (r) => fail('Should return Left'),
      );
    });

    test('should return correct user data', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase();

      // Assert
      result.fold(
        (l) => fail('Should return Right'),
        (user) {
          expect(user.id, tUser.id);
          expect(user.email, tUser.email);
          expect(user.username, tUser.username);
          expect(user.firstName, tUser.firstName);
          expect(user.lastName, tUser.lastName);
          expect(user.token, tUser.token);
        },
      );
    });

    test('should handle connection errors', () async {
      // Arrange
      final failure = AuthFailure.connectionError();
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) {
          expect(l.type, AuthFailureType.connectionError);
          expect(l.message, 'Error de conexión. Verifica tu internet.');
        },
        (r) => fail('Should return Left'),
      );
    });
  });
}
