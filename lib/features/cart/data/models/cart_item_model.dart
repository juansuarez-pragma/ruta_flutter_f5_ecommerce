import 'dart:convert';

import 'package:fake_store_api_client/fake_store_api_client.dart';

import '../../domain/entities/cart_item.dart';

/// Modelo de datos para CartItem.
///
/// Proporciona serialización/deserialización JSON para persistencia.
class CartItemModel {
  final int productId;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;
  final int quantity;

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

  /// Crea un modelo desde un CartItem de dominio.
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

  /// Crea un modelo desde JSON.
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

  /// Convierte el modelo a JSON.
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

  /// Convierte el modelo a una entidad de dominio.
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

  /// Crea una copia con los valores proporcionados.
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

  /// Serializa una lista de modelos a JSON string.
  static String encodeList(List<CartItemModel> items) {
    return jsonEncode(items.map((item) => item.toJson()).toList());
  }

  /// Deserializa una lista de modelos desde JSON string.
  static List<CartItemModel> decodeList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => CartItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
