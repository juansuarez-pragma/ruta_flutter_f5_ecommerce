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
import 'package:ecommerce/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce/features/search/domain/usecases/search_products_usecase.dart';
import 'package:ecommerce/features/auth/auth.dart';
import 'package:ecommerce/features/support/support.dart';

// ============================================================================
// EXTERNAL MOCKS
// ============================================================================

/// SharedPreferences mock for tests.
class MockSharedPreferences extends Mock implements SharedPreferences {}

// ============================================================================
// REPOSITORY MOCKS
// ============================================================================

/// ProductRepository mock for tests.
class MockProductRepository extends Mock implements ProductRepository {}

/// CartRepository mock for tests.
class MockCartRepository extends Mock implements CartRepository {}

/// OrderRepository mock for tests.
class MockOrderRepository extends Mock implements OrderRepository {}

/// AuthRepository mock for tests.
class MockAuthRepository extends Mock implements AuthRepository {}

/// AuthLocalDataSource mock for tests.
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

// ============================================================================
// AUTH USE CASE MOCKS
// ============================================================================

/// LoginUseCase mock for tests.
class MockLoginUseCase extends Mock implements LoginUseCase {}

/// RegisterUseCase mock for tests.
class MockRegisterUseCase extends Mock implements RegisterUseCase {}

/// LogoutUseCase mock for tests.
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// GetCurrentUserUseCase mock for tests.
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

/// Cart use cases mocks.
class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockAddToCartUseCase extends Mock implements AddToCartUseCase {}

class MockRemoveFromCartUseCase extends Mock implements RemoveFromCartUseCase {}

class MockUpdateCartQuantityUseCase extends Mock
    implements UpdateCartQuantityUseCase {}

class MockClearCartUseCase extends Mock implements ClearCartUseCase {}

// ============================================================================
// PRODUCTS & CATEGORIES USE CASE MOCKS
// ============================================================================

/// GetCategoriesUseCase mock for tests.
class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

/// GetProductsUseCase mock for tests.
class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

/// SearchProductsUseCase mock for tests.
class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}

/// GetProductByIdUseCase mock for tests.
class MockGetProductByIdUseCase extends Mock implements GetProductByIdUseCase {}

/// Product fixtures for tests.
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

/// CartItem fixtures for tests.
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

/// User fixtures for auth tests.
class UserFixtures {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String invalidEmail = 'invalid-email';
  static const String weakPassword = '123';

  /// Authenticated test user.
  static const User sampleUser = User(
    id: 1,
    email: validEmail,
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
    token: 'valid_token_abc123',
  );

  /// User without token (unauthenticated).
  static const User sampleUserWithoutToken = User(
    id: 1,
    email: validEmail,
    username: 'testuser',
    firstName: 'Test',
    lastName: 'User',
  );

  /// Basic test user JSON (for datasource tests).
  static Map<String, dynamic> get sampleUserJson => {
    'id': 1,
    'email': validEmail,
    'username': 'testuser',
    'firstName': 'Test',
    'lastName': 'User',
    'token': 'valid_token_abc123',
  };

  /// Valid login credentials.
  static Map<String, String> get validCredentials => {
    'email': validEmail,
    'password': validPassword,
  };

  /// Invalid login credentials.
  static Map<String, String> get invalidCredentials => {
    'email': validEmail,
    'password': 'wrongpassword',
  };
}

// ============================================================================
// SUPPORT FIXTURES
// ============================================================================

/// FAQItem fixtures for support tests.
class FAQFixtures {
  static const FAQItem sampleFAQ = FAQItem(
    id: 1,
    question: 'How can I place an order?',
    answer: 'To place an order, go to the products page...',
    category: FAQCategory.orders,
  );

  static const List<FAQItem> sampleFAQs = [
    sampleFAQ,
    FAQItem(
      id: 2,
      question: 'Which payment methods do you accept?',
      answer: 'We accept credit cards, debit cards, and PayPal.',
      category: FAQCategory.payments,
    ),
    FAQItem(
      id: 3,
      question: 'How can I track my order?',
      answer: 'You can track your order in the "My Orders" section.',
      category: FAQCategory.shipping,
    ),
  ];

  static Map<String, dynamic> get sampleFAQJson => {
    'id': 1,
    'question': 'How can I place an order?',
    'answer': 'To place an order, go to the products page...',
    'category': 'orders',
  };
}

/// ContactMessage fixtures for support tests.
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

  static const String validName = 'Test User';
  static const String validEmail = 'test@example.com';
  static const String validSubject = 'Product inquiry';
  static const String validMessage =
      'This is a valid test message with more than 10 characters.';

  static Map<String, dynamic> get sampleContactMessageJson => {
    'id': '1',
    'name': validName,
    'email': validEmail,
    'subject': validSubject,
    'message': validMessage,
    'timestamp': sampleTimestamp.toIso8601String(),
  };
}

/// ContactInfo fixtures for support tests.
class ContactInfoFixtures {
  static const ContactInfo sampleContactInfo = ContactInfo(
    email: 'support@fakestore.com',
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

/// GetOrdersUseCase mock for tests.
class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}

/// SaveOrderUseCase mock for tests.
class MockSaveOrderUseCase extends Mock implements SaveOrderUseCase {}

/// GetOrderByIdUseCase mock for tests.
class MockGetOrderByIdUseCase extends Mock implements GetOrderByIdUseCase {}

// ============================================================================
// SUPPORT MOCKS
// ============================================================================

/// SupportRepository mock for tests.
class MockSupportRepository extends Mock implements SupportRepository {}

/// SupportLocalDataSource mock for tests.
class MockSupportLocalDataSource extends Mock implements SupportLocalDataSource {}

/// GetFAQsUseCase mock for tests.
class MockGetFAQsUseCase extends Mock implements GetFAQsUseCase {}

/// SendContactMessageUseCase mock for tests.
class MockSendContactMessageUseCase extends Mock
    implements SendContactMessageUseCase {}
