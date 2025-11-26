// This is a basic Flutter widget test.
//
// Tests that verify the app structure and core functionality.

import 'package:flutter_test/flutter_test.dart';

// Domain layer tests - these don't require platform channels
import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

void main() {
  group('CartItem Entity', () {
    test('CartItem calculates total price correctly', () {
      final product = Product(
        id: 1,
        title: 'Test Product',
        price: 29.99,
        description: 'A test product',
        category: 'test',
        image: 'https://example.com/image.png',
        rating: const ProductRating(rate: 4.5, count: 100),
      );

      final cartItem = CartItem(product: product, quantity: 3);

      expect(cartItem.totalPrice, closeTo(89.97, 0.01));
    });

    test('CartItem stores product reference correctly', () {
      final product = Product(
        id: 42,
        title: 'Another Product',
        price: 15.00,
        description: 'Description',
        category: 'category',
        image: 'https://example.com/image2.png',
        rating: const ProductRating(rate: 3.0, count: 50),
      );

      final cartItem = CartItem(product: product, quantity: 1);

      expect(cartItem.product.id, equals(42));
      expect(cartItem.product.title, equals('Another Product'));
      expect(cartItem.quantity, equals(1));
    });
  });

  group('Product Model', () {
    test('Product has correct properties', () {
      final product = Product(
        id: 1,
        title: 'Test',
        price: 10.0,
        description: 'Description',
        category: 'electronics',
        image: 'https://example.com/img.png',
        rating: const ProductRating(rate: 4.0, count: 200),
      );

      expect(product.id, equals(1));
      expect(product.title, equals('Test'));
      expect(product.price, equals(10.0));
      expect(product.category, equals('electronics'));
      expect(product.rating.rate, equals(4.0));
      expect(product.rating.count, equals(200));
    });
  });
}
