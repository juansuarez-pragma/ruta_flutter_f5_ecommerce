import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/repositories/support_repository.dart';

/// Caso de uso para obtener las preguntas frecuentes.
class GetFAQsUseCase {
  const GetFAQsUseCase({required this.repository});

  final SupportRepository repository;

  /// Ejecuta el caso de uso.
  ///
  /// Si [category] es null, retorna todas las FAQs.
  /// Si [category] tiene valor, retorna solo FAQs de esa categoría.
  Future<Either<SupportFailure, List<FAQItem>>> call({
    FAQCategory? category,
  }) {
    if (category != null) {
      return repository.getFAQsByCategory(category);
    }
    return repository.getFAQs();
  }
}
