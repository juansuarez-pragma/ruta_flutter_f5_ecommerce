import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/app_logger.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/features/support/data/datasources/support_local_datasource.dart';
import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/data/models/faq_item_model.dart';
import 'package:ecommerce/features/support/domain/entities/contact_info.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Local support datasource implementation.
class SupportLocalDataSourceImpl implements SupportLocalDataSource {
  SupportLocalDataSourceImpl({
    required this.sharedPreferences,
    required AppLogger logger,
  }) : _logger = logger;

  final SharedPreferences sharedPreferences;
  final AppLogger _logger;
  static const String _contactMessagesKey = 'CACHED_CONTACT_MESSAGES';

  @override
  Future<List<FAQItemModel>> getFAQs() async {
    return _mockFAQs;
  }

  @override
  Future<List<FAQItemModel>> getFAQsByCategory(FAQCategory category) async {
    return _mockFAQs.where((faq) => faq.category == category).toList();
  }

  @override
  Future<ContactMessageModel> saveContactMessage(
    ContactMessageModel message,
  ) async {
    try {
      final messages = await _getCachedMessages();
      messages.add(message);

      final jsonList = messages.map((m) => m.toJson()).toList();
      await sharedPreferences.setString(
        _contactMessagesKey,
        json.encode(jsonList),
      );

      return message;
    } on ParseException {
      rethrow;
    } catch (e, st) {
      final exception = UnknownException(
        message: 'Failed to save contact message',
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      _logger.logAppException(
        exception,
        context: {'operation': 'saveContactMessage'},
        stackTrace: st,
      );

      throw exception;
    }
  }

  @override
  ContactInfo getContactInfo() {
    return const ContactInfo(
      email: 'support@fakestore.com',
      phone: '+1 (555) 123-4567',
      address: '123 Commerce Street, Digital City, DC 12345',
      socialMedia: {
        'facebook': 'facebook.com/fakestore',
        'twitter': '@fakestore',
        'instagram': '@fake.store',
      },
    );
  }

  Future<List<ContactMessageModel>> _getCachedMessages() async {
    final jsonString = sharedPreferences.getString(_contactMessagesKey);
    if (jsonString == null) {
      return [];
    }

    try {
      final jsonList = safeJsonDecode(jsonString) as List<dynamic>;

      return jsonList
          .map(
            (json) => ContactMessageModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } on ParseException {
      _logger.logError(
        message: 'Failed to decode contact messages',
        context: {'operation': '_getCachedMessages'},
      );
      rethrow;
    } catch (e, st) {
      final exception = ParseException(
        message: 'Unexpected error while loading contact messages',
        failedValue: jsonString.length > 200
            ? '${jsonString.substring(0, 200)}...'
            : jsonString,
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      _logger.logAppException(
        exception,
        context: {'operation': '_getCachedMessages'},
        stackTrace: st,
      );

      throw exception;
    }
  }

  static final List<FAQItemModel> _mockFAQs = [
    const FAQItemModel(
      id: 1,
      category: FAQCategory.orders,
      question: 'How can I track my order?',
      answer:
          'You can track your order from the "My Orders" section in your account. Once your order ships, you will receive a tracking number by email.',
    ),
    const FAQItemModel(
      id: 2,
      category: FAQCategory.orders,
      question: 'Can I cancel my order?',
      answer:
          'You can cancel your order within the first 2 hours after placing it. Go to "My Orders", select the order, and tap "Cancel". After that, please contact support.',
    ),
    const FAQItemModel(
      id: 3,
      category: FAQCategory.orders,
      question: 'How long does delivery take?',
      answer:
          'Delivery time depends on your location:\n• Domestic: 3-5 business days\n• Metro area: 1-2 business days\n• International: 10-15 business days',
    ),
    const FAQItemModel(
      id: 4,
      category: FAQCategory.payments,
      question: 'Which payment methods do you accept?',
      answer:
          'We accept:\n• Credit and debit cards (Visa, MasterCard, American Express)\n• PayPal\n• Bank transfers\n• Cash on delivery (in selected areas)',
    ),
    const FAQItemModel(
      id: 5,
      category: FAQCategory.payments,
      question: 'Is it safe to pay online?',
      answer:
          'Yes. We use 256-bit SSL encryption and comply with PCI DSS standards. Your payment data is protected and we never store it on our servers.',
    ),
    const FAQItemModel(
      id: 6,
      category: FAQCategory.payments,
      question: 'Can I get an invoice?',
      answer:
          'Yes. You will receive an electronic invoice by email after completing your purchase. You can also download it from "My Orders" at any time.',
    ),
    const FAQItemModel(
      id: 7,
      category: FAQCategory.shipping,
      question: 'Do you ship internationally?',
      answer:
          'Yes, we ship to more than 50 countries. Shipping costs and delivery times vary by destination. You can check availability and costs during checkout.',
    ),
    const FAQItemModel(
      id: 8,
      category: FAQCategory.shipping,
      question: 'What is the shipping cost?',
      answer:
          'Shipping costs depend on:\n• Destination\n• Package weight\n• Selected shipping method\n\nFree shipping on orders over \$50 (domestic).',
    ),
    const FAQItemModel(
      id: 9,
      category: FAQCategory.shipping,
      question: 'Can I change the shipping address?',
      answer:
          'You can change the shipping address until the order has shipped. Contact support as soon as possible with your order number and the new address.',
    ),
    const FAQItemModel(
      id: 10,
      category: FAQCategory.returns,
      question: 'What is your return policy?',
      answer:
          'We accept returns within 30 days of delivery. The product must be unused, in its original packaging, and with all tags. Refunds are processed in 5-7 business days.',
    ),
    const FAQItemModel(
      id: 11,
      category: FAQCategory.returns,
      question: 'How do I start a return?',
      answer:
          'To start a return:\n1. Go to "My Orders"\n2. Select the product\n3. Tap "Request return"\n4. You will receive instructions by email\n5. Send the product with the provided label',
    ),
    const FAQItemModel(
      id: 12,
      category: FAQCategory.returns,
      question: 'Who pays for return shipping?',
      answer:
          'If the return is due to a product defect or our mistake, we cover the cost. If it is a change of mind, the customer covers return shipping.',
    ),
    const FAQItemModel(
      id: 13,
      category: FAQCategory.account,
      question: 'How do I create an account?',
      answer:
          'Tap "Sign up" at the top. Fill out the form with your name, email, and password. You will receive a confirmation email to activate your account.',
    ),
    const FAQItemModel(
      id: 14,
      category: FAQCategory.account,
      question: 'I forgot my password. What should I do?',
      answer:
          'On the sign-in page, tap "Forgot your password?". Enter your email and you will receive a password reset link.',
    ),
    const FAQItemModel(
      id: 15,
      category: FAQCategory.account,
      question: 'How do I update my personal information?',
      answer:
          'Go to "My Account" > "Profile" to update your name, email, phone, and address. Changes are saved automatically.',
    ),
    const FAQItemModel(
      id: 16,
      category: FAQCategory.general,
      question: 'Do you have physical stores?',
      answer:
          'We currently operate online only. This allows us to offer better prices and a wider catalog. All orders are shipped directly to your address.',
    ),
    const FAQItemModel(
      id: 17,
      category: FAQCategory.general,
      question: 'How do I contact support?',
      answer:
          'You can contact us:\n• Email: support@fakestore.com\n• Phone: +1 (555) 123-4567\n• Contact form in our app\n• Live chat (Mon-Fri 9am-6pm)',
    ),
    const FAQItemModel(
      id: 18,
      category: FAQCategory.general,
      question: 'Are the products authentic?',
      answer:
          'All our products are 100% authentic and come directly from manufacturers or authorized distributors. Each product includes a manufacturer warranty.',
    ),
  ];
}
