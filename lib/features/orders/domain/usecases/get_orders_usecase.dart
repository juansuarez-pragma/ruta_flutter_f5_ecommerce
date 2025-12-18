import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';

/// Use case to fetch order history.
class GetOrdersUseCase {
  GetOrdersUseCase({required OrderRepository repository})
    : _repository = repository;
  final OrderRepository _repository;

  /// Executes the use case.
  Future<List<Order>> call() async {
    final orders = await _repository.getOrders();
    // Sort by date descending (most recent first).
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }
}
