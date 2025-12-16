import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';
import 'package:ecommerce/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:ecommerce/features/orders/domain/usecases/save_order_usecase.dart';
import 'package:ecommerce/features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:ecommerce/features/auth/auth.dart';
import 'package:ecommerce/features/support/support.dart';
import 'package:ecommerce/features/support/data/datasources/support_local_datasource.dart';

// ============================================================================
// EXTERNAL MOCKS
// ============================================================================

/// Mock de SharedPreferences para tests
class MockSharedPreferences extends Mock implements SharedPreferences {}

// ============================================================================
// REPOSITORY MOCKS
// ============================================================================

/// Mock del ProductRepository para tests
class MockProductRepository extends Mock implements ProductRepository {}

/// Mock del CartRepository para tests
class MockCartRepository extends Mock implements CartRepository {}

/// Mock del OrderRepository para tests
class MockOrderRepository extends Mock implements OrderRepository {}

/// Mock del AuthRepository para tests
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock del AuthLocalDataSource para tests
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

// ============================================================================
// AUTH USE CASE MOCKS
// ============================================================================

/// Mock de LoginUseCase para tests
class MockLoginUseCase extends Mock implements LoginUseCase {}

/// Mock de RegisterUseCase para tests
class MockRegisterUseCase extends Mock implements RegisterUseCase {}

/// Mock de LogoutUseCase para tests
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// Mock de GetCurrentUserUseCase para tests
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

/// Mocks de UseCases del Cart
class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockAddToCartUseCase extends Mock implements AddToCartUseCase {}

class MockRemoveFromCartUseCase extends Mock implements RemoveFromCartUseCase {}

class MockUpdateCartQuantityUseCase extends Mock
    implements UpdateCartQuantityUseCase {}

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}

/// Fixtures de productos para tests
class ProductFixtures {
  static Product get sampleProduct => const Product(
    id: 1,
    title: 'Test Product',
    price: 99.99,
    description: 'A test product description',
    category: 'electronics',
    image: 'https://example.com/image.jpg',
    rating: ProductRating(rate: 4.5, count: 100),
  );

  static List<Product> get sampleProducts => [
    sampleProduct,
    const Product(
      id: 2,
      title: 'Another Product',
      price: 49.99,
      description: 'Another description',
      category: 'jewelery',
      image: 'https://example.com/image2.jpg',
      rating: ProductRating(rate: 3.8, count: 50),
    ),
    const Product(
      id: 3,
      title: 'Third Product',
      price: 29.99,
      description: 'Third description',
      category: 'electronics',
      image: 'https://example.com/image3.jpg',
      rating: ProductRating(rate: 4.2, count: 75),
    ),
  ];

  static List<String> get sampleCategories => [
    'electronics',
    'jewelery',
    "men's clothing",
    "women's clothing",
  ];
}

/// Fixtures de CartItem para tests
class CartItemFixtures {
  static CartItem get sampleCartItem =>
      CartItem(product: ProductFixtures.sampleProduct, quantity: 1);

  static List<CartItem> get sampleCartItems => [
    CartItem(product: ProductFixtures.sampleProducts[0], quantity: 2),
    CartItem(product: ProductFixtures.sampleProducts[1], quantity: 1),
  ];

  static CartItem get cartItemWithQuantity3 =>
      CartItem(product: ProductFixtures.sampleProduct, quantity: 3);
}

// ============================================================================
// AUTH FIXTURES
// ============================================================================

/// Fixtures de User para tests de autenticación.
class UserFixtures {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String invalidEmail = 'invalid-email';
  static const String weakPassword = '123';

  /// Usuario de prueba autenticado
  static const User sampleUser = User(
    id: 1,
    email: validEmail,
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'valid_token_abc123',
  );

  /// Usuario sin token (no autenticado)
  static const User sampleUserWithoutToken = User(
    id: 1,
    email: validEmail,
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
  );

  /// Usuario de prueba básico en JSON (para DataSource tests)
  static Map<String, dynamic> get sampleUserJson => {
    'id': 1,
    'email': validEmail,
    'username': 'testuser',
    'firstName': 'Test',
    'lastName': 'User',
    'token': 'valid_token_abc123',
  };

  /// Credenciales válidas para login
  static Map<String, String> get validCredentials => {
    'email': validEmail,
    'password': validPassword,
  };

  /// Credenciales inválidas para login
  static Map<String, String> get invalidCredentials => {
    'email': validEmail,
    'password': 'wrongpassword',
  };
}

// ============================================================================
// SUPPORT FIXTURES
// ============================================================================

/// Fixtures de FAQItem para tests de soporte.
class FAQFixtures {
  static const FAQItem sampleFAQ = FAQItem(
    id: 1,
    question: '¿Cómo puedo realizar un pedido?',
    answer: 'Para realizar un pedido, navegue a la página de productos...',
    category: FAQCategory.orders,
  );

  static const List<FAQItem> sampleFAQs = [
    sampleFAQ,
    FAQItem(
      id: 2,
      question: '¿Cuáles son los métodos de pago?',
      answer: 'Aceptamos tarjetas de crédito, débito y PayPal.',
      category: FAQCategory.payments,
    ),
    FAQItem(
      id: 3,
      question: '¿Cómo puedo rastrear mi pedido?',
      answer: 'Puede rastrear su pedido en la sección "Mis Pedidos".',
      category: FAQCategory.shipping,
    ),
  ];

  static Map<String, dynamic> get sampleFAQJson => {
    'id': 1,
    'question': '¿Cómo puedo realizar un pedido?',
    'answer': 'Para realizar un pedido, navegue a la página de productos...',
    'category': 'orders',
  };
}

/// Fixtures de ContactMessage para tests de soporte.
class ContactMessageFixtures {
  static final DateTime sampleTimestamp = DateTime(2025, 12, 16, 10, 30);

  static ContactMessage get sampleContactMessage => ContactMessage(
    id: '1',
    name: validName,
    email: validEmail,
    subject: validSubject,
    message: validMessage,
    timestamp: sampleTimestamp,
  );

  static const String validName = 'Usuario Test';
  static const String validEmail = 'test@example.com';
  static const String validSubject = 'Consulta sobre producto';
  static const String validMessage = 'Este es un mensaje de prueba válido que tiene más de 10 caracteres.';

  static Map<String, dynamic> get sampleContactMessageJson => {
    'id': '1',
    'name': validName,
    'email': validEmail,
    'subject': validSubject,
    'message': validMessage,
    'timestamp': sampleTimestamp.toIso8601String(),
  };
}

/// Fixtures de ContactInfo para tests de soporte.
class ContactInfoFixtures {
  static const ContactInfo sampleContactInfo = ContactInfo(
    email: 'soporte@fakestore.com',
    phone: '+1 234 567 890',
    address: '123 Main Street, City, Country',
    socialMedia: {
      'twitter': '@fakestore',
      'instagram': '@fakestore',
    },
  );
}

// ============================================================================
// ORDER USE CASE MOCKS
// ============================================================================

/// Mock de GetOrdersUseCase para tests
class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}

/// Mock de SaveOrderUseCase para tests
class MockSaveOrderUseCase extends Mock implements SaveOrderUseCase {}

/// Mock de GetOrderByIdUseCase para tests
class MockGetOrderByIdUseCase extends Mock implements GetOrderByIdUseCase {}

// ============================================================================
// SUPPORT MOCKS
// ============================================================================

/// Mock del SupportRepository para tests
class MockSupportRepository extends Mock implements SupportRepository {}

/// Mock del SupportLocalDataSource para tests
class MockSupportLocalDataSource extends Mock implements SupportLocalDataSource {}

/// Mock de GetFAQsUseCase para tests
class MockGetFAQsUseCase extends Mock implements GetFAQsUseCase {}

/// Mock de SendContactMessageUseCase para tests
class MockSendContactMessageUseCase extends Mock
    implements SendContactMessageUseCase {}
