import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// FAQItem data model with JSON serialization.
class FAQItemModel extends FAQItem {
  const FAQItemModel({
    required super.id,
    required super.question,
    required super.answer,
    required super.category,
  });

  /// Creates an instance from JSON.
  factory FAQItemModel.fromJson(Map<String, dynamic> json) {
    return FAQItemModel(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: _categoryFromString(json['category'] as String),
    );
  }

  /// Creates an instance from a domain entity.
  factory FAQItemModel.fromEntity(FAQItem entity) {
    return FAQItemModel(
      id: entity.id,
      question: entity.question,
      answer: entity.answer,
      category: entity.category,
    );
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': _categoryToString(category),
    };
  }

  /// Converts the model to a domain entity.
  FAQItem toEntity() {
    return FAQItem(
      id: id,
      question: question,
      answer: answer,
      category: category,
    );
  }

  /// Converts a string to FAQCategory.
  static FAQCategory _categoryFromString(String category) {
    return FAQCategory.values.firstWhere(
      (e) => e.name == category,
      orElse: () => FAQCategory.general,
    );
  }

  /// Converts FAQCategory to string.
  static String _categoryToString(FAQCategory category) {
    return category.name;
  }
}
