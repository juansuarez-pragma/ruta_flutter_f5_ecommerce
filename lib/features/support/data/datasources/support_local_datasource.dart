import 'package:ecommerce/features/support/data/models/faq_item_model.dart';
import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/domain/entities/contact_info.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Fuente de datos local para operaciones de soporte.
abstract class SupportLocalDataSource {
  /// Obtiene la lista de preguntas frecuentes.
  Future<List<FAQItemModel>> getFAQs();

  /// Obtiene FAQs filtradas por categoría.
  Future<List<FAQItemModel>> getFAQsByCategory(FAQCategory category);

  /// Guarda un mensaje de contacto localmente.
  Future<ContactMessageModel> saveContactMessage(ContactMessageModel message);

  /// Obtiene la información de contacto de la tienda.
  ContactInfo getContactInfo();
}
