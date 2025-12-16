import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/auth/auth.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(repository: mockRepository);
  });

  group('LogoutUseCase', () {
    test('should return void when logout is successful', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(null));
      verify(() => mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when logout fails', () async {
      // Arrange
      final failure = AuthFailure.unknown('Error al cerrar sesión');
      when(() => mockRepository.logout()).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, AuthFailureType.unknown),
        (r) => fail('Should return Left'),
      );
    });

    test('should call repository logout method once', () async {
      // Arrange
      when(() => mockRepository.logout()).thenAnswer((_) async => const Right(null));

      // Act
      await useCase();

      // Assert
      verify(() => mockRepository.logout()).called(1);
    });
  });
}
