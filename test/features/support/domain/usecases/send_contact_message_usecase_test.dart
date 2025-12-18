import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/support/support.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late SendContactMessageUseCase useCase;
  late MockSupportRepository mockRepository;

  setUp(() {
    mockRepository = MockSupportRepository();
    useCase = SendContactMessageUseCase(repository: mockRepository);
  });

  final tContactMessage = ContactMessageFixtures.sampleContactMessage;
  const tName = ContactMessageFixtures.validName;
  const tEmail = ContactMessageFixtures.validEmail;
  const tSubject = ContactMessageFixtures.validSubject;
  const tMessage = ContactMessageFixtures.validMessage;

  group('SendContactMessageUseCase', () {
    test('should return ContactMessage when all validations pass', () async {
      // Arrange
      when(() => mockRepository.sendContactMessage(
        name: any(named: 'name'),
        email: any(named: 'email'),
        subject: any(named: 'subject'),
        message: any(named: 'message'),
      )).thenAnswer((_) async => Right(tContactMessage));

      // Act
      final result = await useCase(
        name: tName,
        email: tEmail,
        subject: tSubject,
        message: tMessage,
      );

      // Assert
      expect(result.isRight(), true);
      verify(() => mockRepository.sendContactMessage(
        name: tName,
        email: tEmail,
        subject: tSubject,
        message: tMessage,
      )).called(1);
    });

    group('validation', () {
      test('should return failure when name is empty', () async {
        // Act
        final result = await useCase(
          name: '',
          email: tEmail,
          subject: tSubject,
          message: tMessage,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.type, SupportFailureType.validationFailed);
            expect(l.message, 'Name is required');
          },
          (r) => fail('Should return Left'),
        );
        verifyNever(() => mockRepository.sendContactMessage(
          name: any(named: 'name'),
          email: any(named: 'email'),
          subject: any(named: 'subject'),
          message: any(named: 'message'),
        ));
      });

      test('should return failure when email is empty', () async {
        // Act
        final result = await useCase(
          name: tName,
          email: '',
          subject: tSubject,
          message: tMessage,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.type, SupportFailureType.validationFailed);
            expect(l.message, 'Email is required');
          },
          (r) => fail('Should return Left'),
        );
      });

      test('should return failure when email is invalid', () async {
        // Act
        final result = await useCase(
          name: tName,
          email: 'invalid-email',
          subject: tSubject,
          message: tMessage,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.type, SupportFailureType.validationFailed);
            expect(l.message, 'Email is not valid');
          },
          (r) => fail('Should return Left'),
        );
      });

      test('should return failure when subject is empty', () async {
        // Act
        final result = await useCase(
          name: tName,
          email: tEmail,
          subject: '',
          message: tMessage,
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.type, SupportFailureType.validationFailed);
            expect(l.message, 'Subject is required');
          },
          (r) => fail('Should return Left'),
        );
      });

      test('should return failure when message is empty', () async {
        // Act
        final result = await useCase(
          name: tName,
          email: tEmail,
          subject: tSubject,
          message: '',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.type, SupportFailureType.validationFailed);
            expect(l.message, 'Message is required');
          },
          (r) => fail('Should return Left'),
        );
      });

      test('should return failure when message is too short', () async {
        // Act
        final result = await useCase(
          name: tName,
          email: tEmail,
          subject: tSubject,
          message: 'Short',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (l) {
            expect(l.type, SupportFailureType.validationFailed);
            expect(l.message, 'Message must be at least 10 characters');
          },
          (r) => fail('Should return Left'),
        );
      });

      test('should trim whitespace from fields', () async {
        // Arrange
        when(() => mockRepository.sendContactMessage(
          name: any(named: 'name'),
          email: any(named: 'email'),
          subject: any(named: 'subject'),
          message: any(named: 'message'),
        )).thenAnswer((_) async => Right(tContactMessage));

        // Act
        await useCase(
          name: '  $tName  ',
          email: '  $tEmail  ',
          subject: '  $tSubject  ',
          message: '  $tMessage  ',
        );

        // Assert
        verify(() => mockRepository.sendContactMessage(
          name: tName,
          email: tEmail,
          subject: tSubject,
          message: tMessage,
        )).called(1);
      });
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = SupportFailure.sendMessageFailed();
      when(() => mockRepository.sendContactMessage(
        name: any(named: 'name'),
        email: any(named: 'email'),
        subject: any(named: 'subject'),
        message: any(named: 'message'),
      )).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(
        name: tName,
        email: tEmail,
        subject: tSubject,
        message: tMessage,
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, SupportFailureType.sendMessageFailed),
        (r) => fail('Should return Left'),
      );
    });
  });
}
