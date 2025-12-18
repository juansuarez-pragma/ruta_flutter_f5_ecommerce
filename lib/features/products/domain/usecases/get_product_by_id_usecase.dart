import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Use case for retrieving a product by id.
class GetProductByIdUseCase {
  GetProductByIdUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Executes the use case.
  Future<Either<FakeStoreFailure, Product>> call(int id) async {
    return _repository.getProductById(id);
  }
}
