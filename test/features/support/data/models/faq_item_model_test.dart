import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/features/support/data/models/faq_item_model.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import '../../../../helpers/mocks.dart';

void main() {
  const tFAQItemModel = FAQItemModel(
    id: 1,
    question: 'How can I place an order?',
    answer: 'To place an order, go to the products page...',
    category: FAQCategory.orders,
  );

  group('FAQItemModel', () {
    test('should be a subclass of FAQItem entity', () {
      expect(tFAQItemModel, isA<FAQItem>());
    });

    group('fromJson', () {
      test('should return a valid model', () {
        // Arrange
        final json = FAQFixtures.sampleFAQJson;

        // Act
        final result = FAQItemModel.fromJson(json);

        // Assert
        expect(result, tFAQItemModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tFAQItemModel.toJson();

        // Assert
        expect(result['id'], 1);
        expect(result['question'], 'How can I place an order?');
        expect(result['answer'], 'To place an order, go to the products page...');
        expect(result['category'], 'orders');
      });
    });

    group('toEntity', () {
      test('should return a FAQItem entity with the same values', () {
        // Act
        final result = tFAQItemModel.toEntity();

        // Assert
        expect(result, isA<FAQItem>());
        expect(result.id, tFAQItemModel.id);
        expect(result.question, tFAQItemModel.question);
        expect(result.answer, tFAQItemModel.answer);
        expect(result.category, tFAQItemModel.category);
      });
    });

    group('fromEntity', () {
      test('should return a FAQItemModel from a FAQItem entity', () {
        // Arrange
        const entity = FAQItem(
          id: 1,
          question: 'Test question',
          answer: 'Test answer',
          category: FAQCategory.general,
        );

        // Act
        final result = FAQItemModel.fromEntity(entity);

        // Assert
        expect(result, isA<FAQItemModel>());
        expect(result.id, entity.id);
        expect(result.question, entity.question);
        expect(result.answer, entity.answer);
        expect(result.category, entity.category);
      });
    });
  });
}
