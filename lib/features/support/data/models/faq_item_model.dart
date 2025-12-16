import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Modelo de datos para FAQItem con serialización JSON.
class FAQItemModel extends FAQItem {
  const FAQItemModel({
    required super.id,
    required super.question,
    required super.answer,
    required super.category,
  });

  /// Crea una instancia desde JSON.
  factory FAQItemModel.fromJson(Map<String, dynamic> json) {
    return FAQItemModel(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: _categoryFromString(json['category'] as String),
    );
  }

  /// Convierte la instancia a JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': _categoryToString(category),
    };
  }

  /// Crea una instancia desde una entidad del dominio.
  factory FAQItemModel.fromEntity(FAQItem entity) {
    return FAQItemModel(
      id: entity.id,
      question: entity.question,
      answer: entity.answer,
      category: entity.category,
    );
  }

  /// Convierte el modelo a entidad del dominio.
  FAQItem toEntity() {
    return FAQItem(
      id: id,
      question: question,
      answer: answer,
      category: category,
    );
  }

  /// Convierte string a FAQCategory.
  static FAQCategory _categoryFromString(String category) {
    return FAQCategory.values.firstWhere(
      (e) => e.name == category,
      orElse: () => FAQCategory.general,
    );
  }

  /// Convierte FAQCategory a string.
  static String _categoryToString(FAQCategory category) {
    return category.name;
  }
}
