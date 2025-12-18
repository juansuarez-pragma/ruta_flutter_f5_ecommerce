import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/features/support/support.dart';

void main() {
  group('FAQItem Entity', () {
    const tFAQItem = FAQItem(
      id: 1,
      question: 'How can I place an order?',
      answer: 'To place an order, go to the products page...',
      category: FAQCategory.orders,
    );

    test('should be a valid FAQItem', () {
      expect(tFAQItem.id, 1);
      expect(tFAQItem.question, 'How can I place an order?');
      expect(tFAQItem.category, FAQCategory.orders);
    });

    test('two FAQItems with same properties should be equal', () {
      const faq1 = FAQItem(
        id: 1,
        question: 'Question',
        answer: 'Answer',
        category: FAQCategory.general,
      );

      const faq2 = FAQItem(
        id: 1,
        question: 'Question',
        answer: 'Answer',
        category: FAQCategory.general,
      );

      expect(faq1, faq2);
    });

    test('two FAQItems with different properties should not be equal', () {
      const faq1 = FAQItem(
        id: 1,
        question: 'Question 1',
        answer: 'Answer',
        category: FAQCategory.general,
      );

      const faq2 = FAQItem(
        id: 2,
        question: 'Question 2',
        answer: 'Answer',
        category: FAQCategory.general,
      );

      expect(faq1, isNot(faq2));
    });

    test('props should contain all properties', () {
      expect(tFAQItem.props, [
        tFAQItem.id,
        tFAQItem.question,
        tFAQItem.answer,
        tFAQItem.category,
      ]);
    });
  });

  group('FAQCategory', () {
    test('should have all expected values', () {
      expect(FAQCategory.values.length, 6);
      expect(FAQCategory.values, contains(FAQCategory.orders));
      expect(FAQCategory.values, contains(FAQCategory.payments));
      expect(FAQCategory.values, contains(FAQCategory.shipping));
      expect(FAQCategory.values, contains(FAQCategory.returns));
      expect(FAQCategory.values, contains(FAQCategory.account));
      expect(FAQCategory.values, contains(FAQCategory.general));
    });
  });
}
