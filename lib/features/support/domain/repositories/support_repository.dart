import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/support/domain/entities/contact_info.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/entities/contact_message.dart';
import 'package:ecommerce/features/support/domain/failures/support_failure.dart';

export 'package:ecommerce/features/support/domain/failures/support_failure.dart';
export 'package:ecommerce/features/support/domain/failures/support_failure_type.dart';

/// Abstract repository for support operations.
abstract class SupportRepository {
  /// Returns the FAQ list.
  Future<Either<SupportFailure, List<FAQItem>>> getFAQs();

  /// Returns FAQs filtered by category.
  Future<Either<SupportFailure, List<FAQItem>>> getFAQsByCategory(
    FAQCategory category,
  );

  /// Sends a contact message.
  Future<Either<SupportFailure, ContactMessage>> sendContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  });

  /// Returns store contact information.
  Future<Either<SupportFailure, ContactInfo>> getContactInfo();
}
