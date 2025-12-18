import 'package:ecommerce/features/orders/data/datasources/order_local_datasource.dart';
import 'package:ecommerce/features/orders/data/models/order_model.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';

/// Orders repository implementation.
class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required OrderLocalDataSource localDataSource})
    : _localDataSource = localDataSource;
  final OrderLocalDataSource _localDataSource;

  @override
  Future<List<Order>> getOrders() async {
    return _localDataSource.getOrders();
  }

  @override
  Future<void> saveOrder(Order order) async {
    final orderModel = OrderModel.fromEntity(order);
    await _localDataSource.saveOrder(orderModel);
  }

  @override
  Future<Order?> getOrderById(String id) async {
    return _localDataSource.getOrderById(id);
  }

  @override
  Future<void> deleteOrder(String id) async {
    await _localDataSource.deleteOrder(id);
  }
}
