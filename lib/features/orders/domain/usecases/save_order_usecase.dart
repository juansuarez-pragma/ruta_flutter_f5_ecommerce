import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/domain/repositories/order_repository.dart';

/// Use case for saving a new order.
class SaveOrderUseCase {
  SaveOrderUseCase({required OrderRepository repository})
    : _repository = repository;
  final OrderRepository _repository;

  /// Executes the use case.
  Future<void> call(Order order) async {
    await _repository.saveOrder(order);
  }
}
