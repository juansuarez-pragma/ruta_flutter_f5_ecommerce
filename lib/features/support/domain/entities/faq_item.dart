import 'package:equatable/equatable.dart';

/// Categorías de preguntas frecuentes.
enum FAQCategory {
  orders,
  payments,
  shipping,
  returns,
  account,
  general,
}

/// Entidad que representa una pregunta frecuente.
class FAQItem extends Equatable {
  const FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  /// Identificador único de la FAQ.
  final int id;

  /// Pregunta.
  final String question;

  /// Respuesta.
  final String answer;

  /// Categoría de la pregunta.
  final FAQCategory category;

  @override
  List<Object?> get props => [id, question, answer, category];
}
