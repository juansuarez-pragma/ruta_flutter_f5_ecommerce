import 'package:ecommerce/features/orders/data/models/order_model.dart';

/// DataSource local para órdenes usando SharedPreferences.
abstract class OrderLocalDataSource {
  /// Obtiene todas las órdenes guardadas.
  Future<List<OrderModel>> getOrders();

  /// Guarda una orden.
  Future<void> saveOrder(OrderModel order);

  /// Obtiene una orden por ID.
  Future<OrderModel?> getOrderById(String id);

  /// Elimina una orden por ID.
  Future<void> deleteOrder(String id);
}
