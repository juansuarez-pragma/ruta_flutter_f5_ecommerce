import 'package:equatable/equatable.dart';

/// Entity representing a purchase order.
class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = OrderStatus.completed,
  });

  /// Unique order identifier.
  final String id;

  /// Order items.
  final List<OrderItem> items;

  /// Order total.
  final double total;

  /// Order creation date.
  final DateTime createdAt;

  /// Order status.
  final OrderStatus status;

  /// Total number of products in the order.
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [id, items, total, createdAt, status];
}

/// Order item.
class OrderItem extends Equatable {
  const OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  /// Product ID.
  final int productId;

  /// Product title.
  final String title;

  /// Unit price.
  final double price;

  /// Quantity.
  final int quantity;

  /// Image URL.
  final String imageUrl;

  /// Total price for this item.
  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [productId, title, price, quantity, imageUrl];
}

/// Possible order statuses.
enum OrderStatus { pending, completed, cancelled }

extension OrderStatusExtension on OrderStatus {
  String get key {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return OrderStatus.pending;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.completed;
    }
  }
}
