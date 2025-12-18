import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/error_logger.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/features/support/data/datasources/support_local_datasource.dart';
import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/data/models/faq_item_model.dart';
import 'package:ecommerce/features/support/domain/entities/contact_info.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Implementación del datasource local de soporte.
class SupportLocalDataSourceImpl implements SupportLocalDataSource {
  SupportLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
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
        message: 'Error al guardar mensaje de contacto',
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      ErrorLogger().logAppException(
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
      email: 'soporte@fakestore.com',
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
      ErrorLogger().logError(
        message: 'Error al decodificar mensajes de contacto',
        context: {'operation': '_getCachedMessages'},
      );
      rethrow;
    } catch (e, st) {
      final exception = ParseException(
        message: 'Error inesperado al cargar mensajes de contacto',
        failedValue: jsonString.length > 200
            ? '${jsonString.substring(0, 200)}...'
            : jsonString,
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      ErrorLogger().logAppException(
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
      question: '¿Cómo puedo rastrear mi pedido?',
      answer:
          'Puedes rastrear tu pedido desde la sección "Mis Pedidos" en tu cuenta. Una vez que tu pedido sea enviado, recibirás un número de seguimiento por correo electrónico.',
    ),
    const FAQItemModel(
      id: 2,
      category: FAQCategory.orders,
      question: '¿Puedo cancelar mi pedido?',
      answer:
          'Puedes cancelar tu pedido dentro de las primeras 2 horas después de realizarlo. Ve a "Mis Pedidos", selecciona el pedido y presiona "Cancelar". Después de este tiempo, contacta a soporte.',
    ),
    const FAQItemModel(
      id: 3,
      category: FAQCategory.orders,
      question: '¿Cuánto tiempo tarda la entrega?',
      answer:
          'El tiempo de entrega varía según tu ubicación:\n• Nacional: 3-5 días hábiles\n• Área metropolitana: 1-2 días hábiles\n• Internacional: 10-15 días hábiles',
    ),
    const FAQItemModel(
      id: 4,
      category: FAQCategory.payments,
      question: '¿Qué métodos de pago aceptan?',
      answer:
          'Aceptamos:\n• Tarjetas de crédito y débito (Visa, MasterCard, American Express)\n• PayPal\n• Transferencias bancarias\n• Pago contra entrega (en áreas seleccionadas)',
    ),
    const FAQItemModel(
      id: 5,
      category: FAQCategory.payments,
      question: '¿Es seguro pagar en línea?',
      answer:
          'Sí, utilizamos encriptación SSL de 256 bits y cumplimos con los estándares PCI DSS. Tus datos de pago están completamente protegidos y nunca los almacenamos en nuestros servidores.',
    ),
    const FAQItemModel(
      id: 6,
      category: FAQCategory.payments,
      question: '¿Puedo obtener una factura?',
      answer:
          'Sí, recibirás una factura electrónica por correo después de completar tu compra. También puedes descargarla desde "Mis Pedidos" en cualquier momento.',
    ),
    const FAQItemModel(
      id: 7,
      category: FAQCategory.shipping,
      question: '¿Hacen envíos internacionales?',
      answer:
          'Sí, enviamos a más de 50 países. Los costos y tiempos de envío varían según el destino. Puedes verificar la disponibilidad y costos durante el checkout.',
    ),
    const FAQItemModel(
      id: 8,
      category: FAQCategory.shipping,
      question: '¿Cuál es el costo de envío?',
      answer:
          'Los costos de envío varían según:\n• Ubicación del destino\n• Peso del paquete\n• Método de envío seleccionado\n\nEnvío gratis en pedidos superiores a \$50 dentro del país.',
    ),
    const FAQItemModel(
      id: 9,
      category: FAQCategory.shipping,
      question: '¿Puedo cambiar la dirección de envío?',
      answer:
          'Puedes cambiar la dirección de envío hasta que el pedido sea enviado. Contacta a soporte lo antes posible con tu número de pedido y la nueva dirección.',
    ),
    const FAQItemModel(
      id: 10,
      category: FAQCategory.returns,
      question: '¿Cuál es su política de devoluciones?',
      answer:
          'Aceptamos devoluciones dentro de 30 días después de la entrega. El producto debe estar en su empaque original, sin usar y con todas las etiquetas. El reembolso se procesa en 5-7 días hábiles.',
    ),
    const FAQItemModel(
      id: 11,
      category: FAQCategory.returns,
      question: '¿Cómo inicio una devolución?',
      answer:
          'Para iniciar una devolución:\n1. Ve a "Mis Pedidos"\n2. Selecciona el producto\n3. Presiona "Solicitar devolución"\n4. Recibirás instrucciones por correo\n5. Envía el producto con la etiqueta proporcionada',
    ),
    const FAQItemModel(
      id: 12,
      category: FAQCategory.returns,
      question: '¿Quién paga el envío de devolución?',
      answer:
          'Si la devolución es por defecto del producto o error nuestro, cubrimos el costo. Si es por cambio de opinión, el cliente cubre el envío de retorno.',
    ),
    const FAQItemModel(
      id: 13,
      category: FAQCategory.account,
      question: '¿Cómo creo una cuenta?',
      answer:
          'Haz clic en "Registrarse" en la parte superior. Completa el formulario con tu nombre, email y contraseña. Recibirás un correo de confirmación para activar tu cuenta.',
    ),
    const FAQItemModel(
      id: 14,
      category: FAQCategory.account,
      question: '¿Olvidé mi contraseña, qué hago?',
      answer:
          'En la página de inicio de sesión, haz clic en "¿Olvidaste tu contraseña?". Ingresa tu email y recibirás un enlace para restablecer tu contraseña.',
    ),
    const FAQItemModel(
      id: 15,
      category: FAQCategory.account,
      question: '¿Cómo actualizo mi información personal?',
      answer:
          'Ve a "Mi Cuenta" > "Perfil" para actualizar tu nombre, email, teléfono y dirección. Los cambios se guardan automáticamente.',
    ),
    const FAQItemModel(
      id: 16,
      category: FAQCategory.general,
      question: '¿Tienen tiendas físicas?',
      answer:
          'Actualmente solo operamos en línea. Esto nos permite ofrecer mejores precios y un catálogo más amplio. Todos los pedidos se envían directamente a tu domicilio.',
    ),
    const FAQItemModel(
      id: 17,
      category: FAQCategory.general,
      question: '¿Cómo contacto con soporte?',
      answer:
          'Puedes contactarnos:\n• Email: soporte@fakestore.com\n• Teléfono: +1 (555) 123-4567\n• Formulario de contacto en nuestra app\n• Chat en vivo (L-V 9am-6pm)',
    ),
    const FAQItemModel(
      id: 18,
      category: FAQCategory.general,
      question: '¿Los productos son originales?',
      answer:
          'Todos nuestros productos son 100% originales y vienen directamente de los fabricantes o distribuidores autorizados. Cada producto incluye garantía del fabricante.',
    ),
  ];
}
