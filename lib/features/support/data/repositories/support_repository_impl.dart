import 'package:dartz/dartz.dart';

import 'package:ecommerce/core/utils/id_generator.dart';
import 'package:ecommerce/features/support/data/datasources/support_local_datasource.dart';
import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/domain/entities/contact_message.dart';
import 'package:ecommerce/features/support/domain/entities/contact_info.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/repositories/support_repository.dart';

/// Support repository implementation.
class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl({required this.localDataSource, required IdGenerator idGenerator})
    : _idGenerator = idGenerator;

  final SupportLocalDataSource localDataSource;
  final IdGenerator _idGenerator;

  @override
  Future<Either<SupportFailure, List<FAQItem>>> getFAQs() async {
    try {
      final faqs = await localDataSource.getFAQs();
      return Right(faqs);
    } catch (e) {
      return Left(SupportFailure.loadFaqsFailed());
    }
  }

  @override
  Future<Either<SupportFailure, List<FAQItem>>> getFAQsByCategory(
    FAQCategory category,
  ) async {
    try {
      final faqs = await localDataSource.getFAQsByCategory(category);
      return Right(faqs);
    } catch (e) {
      return Left(SupportFailure.loadFaqsFailed());
    }
  }

  @override
  Future<Either<SupportFailure, ContactMessage>> sendContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      final contactMessage = ContactMessageModel(
        id: _idGenerator.generate(),
        name: name,
        email: email,
        subject: subject,
        message: message,
        timestamp: DateTime.now(),
      );

      final savedMessage =
          await localDataSource.saveContactMessage(contactMessage);

      return Right(savedMessage);
    } catch (e) {
      return Left(SupportFailure.sendMessageFailed());
    }
  }

  @override
  Future<Either<SupportFailure, ContactInfo>> getContactInfo() async {
    try {
      final contactInfo = localDataSource.getContactInfo();
      return Right(contactInfo);
    } catch (e) {
      return Left(SupportFailure.unknown());
    }
  }
}
