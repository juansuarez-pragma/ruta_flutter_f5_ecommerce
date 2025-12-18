import 'package:ecommerce/features/orders/data/models/order_model.dart';

/// Local data source for orders using SharedPreferences.
abstract class OrderLocalDataSource {
  /// Returns all saved orders.
  Future<List<OrderModel>> getOrders();

  /// Saves an order.
  Future<void> saveOrder(OrderModel order);

  /// Returns an order by id.
  Future<OrderModel?> getOrderById(String id);

  /// Deletes an order by id.
  Future<void> deleteOrder(String id);
}
