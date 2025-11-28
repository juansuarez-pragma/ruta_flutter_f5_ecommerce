import 'package:ecommerce/features/orders/domain/entities/order.dart';

/// Repositorio abstracto para gestión de órdenes.
abstract class OrderRepository {
  /// Obtiene todas las órdenes.
  Future<List<Order>> getOrders();

  /// Guarda una nueva orden.
  Future<void> saveOrder(Order order);

  /// Obtiene una orden por su ID.
  Future<Order?> getOrderById(String id);

  /// Elimina una orden.
  Future<void> deleteOrder(String id);
}
