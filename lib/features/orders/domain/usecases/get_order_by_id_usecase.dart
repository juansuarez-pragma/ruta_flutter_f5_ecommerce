import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';

/// Use case for retrieving an order by id.
class GetOrderByIdUseCase {
  GetOrderByIdUseCase({required OrderRepository repository})
    : _repository = repository;
  final OrderRepository _repository;

  /// Executes the use case.
  Future<Order?> call(String orderId) async {
    return _repository.getOrderById(orderId);
  }
}
