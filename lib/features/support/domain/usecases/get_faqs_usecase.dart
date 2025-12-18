import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/repositories/support_repository.dart';

/// Use case for retrieving FAQs.
class GetFAQsUseCase {
  const GetFAQsUseCase({required this.repository});

  final SupportRepository repository;

  /// Executes the use case.
  ///
  /// If [category] is null, returns all FAQs.
  /// If [category] is provided, returns only FAQs for that category.
  Future<Either<SupportFailure, List<FAQItem>>> call({
    FAQCategory? category,
  }) {
    if (category != null) {
      return repository.getFAQsByCategory(category);
    }
    return repository.getFAQs();
  }
}
