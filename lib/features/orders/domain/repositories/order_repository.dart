import 'package:ecommerce/features/orders/domain/entities/order.dart';

/// Abstract repository for order management.
abstract class OrderRepository {
  /// Fetches all orders.
  Future<List<Order>> getOrders();

  /// Saves a new order.
  Future<void> saveOrder(Order order);

  /// Fetches an order by its ID.
  Future<Order?> getOrderById(String id);

  /// Deletes an order by ID.
  Future<void> deleteOrder(String id);
}
