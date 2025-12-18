import 'dart:convert';

import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';

/// CartItem data model.
///
/// Provides JSON serialization/deserialization for persistence.
class CartItemModel {
  const CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
    required this.quantity,
  });

  /// Creates a model from a domain CartItem.
  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      productId: item.product.id,
      title: item.product.title,
      price: item.product.price,
      description: item.product.description,
      category: item.product.category,
      image: item.product.image,
      ratingRate: item.product.rating.rate,
      ratingCount: item.product.rating.count,
      quantity: item.quantity,
    );
  }

  /// Creates a model from JSON.
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      ratingRate: (json['ratingRate'] as num).toDouble(),
      ratingCount: json['ratingCount'] as int,
      quantity: json['quantity'] as int,
    );
  }
  final int productId;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;
  final int quantity;

  /// Converts the model to JSON.
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'ratingRate': ratingRate,
      'ratingCount': ratingCount,
      'quantity': quantity,
    };
  }

  /// Converts the model to a domain entity.
  CartItem toEntity() {
    return CartItem(
      product: Product(
        id: productId,
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
        rating: ProductRating(rate: ratingRate, count: ratingCount),
      ),
      quantity: quantity,
    );
  }

  /// Creates a copy with the provided values.
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      productId: productId,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      ratingRate: ratingRate,
      ratingCount: ratingCount,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Serializes a list of models to a JSON string.
  static String encodeList(List<CartItemModel> items) {
    return jsonEncode(items.map((item) => item.toJson()).toList());
  }

  /// Deserializes a list of models from a JSON string.
  static List<CartItemModel> decodeList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => CartItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
