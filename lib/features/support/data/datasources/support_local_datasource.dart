import 'package:ecommerce/features/support/data/models/faq_item_model.dart';
import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/domain/entities/contact_info.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Local data source for support operations.
abstract class SupportLocalDataSource {
  /// Returns the list of FAQs.
  Future<List<FAQItemModel>> getFAQs();

  /// Returns FAQs filtered by category.
  Future<List<FAQItemModel>> getFAQsByCategory(FAQCategory category);

  /// Saves a contact message locally.
  Future<ContactMessageModel> saveContactMessage(ContactMessageModel message);

  /// Returns the store's contact information.
  ContactInfo getContactInfo();
}
