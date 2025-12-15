import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:ecommerce/features/cart/domain/usecases/clear_cart_usecase.dart';

/// Mock del ProductRepository para tests
class MockProductRepository extends Mock implements ProductRepository {}

/// Mock del CartRepository para tests
class MockCartRepository extends Mock implements CartRepository {}

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
