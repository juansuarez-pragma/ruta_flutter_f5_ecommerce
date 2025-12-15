import 'package:equatable/equatable.dart';

/// Entidad que representa una orden de compra.
class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = OrderStatus.completed,
  });

  /// Identificador único de la orden.
  final String id;

  /// Lista de items de la orden.
  final List<OrderItem> items;

  /// Total de la orden.
  final double total;

  /// Fecha de creación de la orden.
  final DateTime createdAt;

  /// Estado de la orden.
  final OrderStatus status;

  /// Número total de productos en la orden.
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [id, items, total, createdAt, status];
}

/// Item de una orden.
class OrderItem extends Equatable {
  const OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  /// ID del producto.
  final int productId;

  /// Título del producto.
  final String title;

  /// Precio unitario.
  final double price;

  /// Cantidad.
  final int quantity;

  /// URL de la imagen.
  final String imageUrl;

  /// Precio total del item.
  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [productId, title, price, quantity, imageUrl];
}

/// Estados posibles de una orden.
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
