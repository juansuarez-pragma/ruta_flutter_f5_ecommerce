import 'package:ecommerce/features/orders/domain/entities/order.dart';

/// Data model for [Order] with JSON serialization.
class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.items,
    required super.total,
    required super.createdAt,
    super.status,
  });

  /// Creates an [OrderModel] from an [Order] entity.
  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      items: order.items
          .map((item) => OrderItemModel.fromEntity(item))
          .toList(),
      total: order.total,
      createdAt: order.createdAt,
      status: order.status,
    );
  }

  /// Creates an [OrderModel] from JSON.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: OrderStatusExtension.fromString(json['status'] as String),
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'status': status.key,
    };
  }
}

/// Data model for [OrderItem] with JSON serialization.
class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.quantity,
    required super.imageUrl,
  });

  /// Creates an [OrderItemModel] from an [OrderItem] entity.
  factory OrderItemModel.fromEntity(OrderItem item) {
    return OrderItemModel(
      productId: item.productId,
      title: item.title,
      price: item.price,
      quantity: item.quantity,
      imageUrl: item.imageUrl,
    );
  }

  /// Creates an [OrderItemModel] from JSON.
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
