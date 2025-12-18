import 'package:equatable/equatable.dart';

/// FAQ categories.
enum FAQCategory {
  orders,
  payments,
  shipping,
  returns,
  account,
  general,
}

/// Entity that represents a FAQ item.
class FAQItem extends Equatable {
  const FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });

  /// FAQ unique identifier.
  final int id;

  /// Question.
  final String question;

  /// Answer.
  final String answer;

  /// Question category.
  final FAQCategory category;

  @override
  List<Object?> get props => [id, question, answer, category];
}
