import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Use case for retrieving all products.
class GetProductsUseCase {
  GetProductsUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Executes the use case.
  Future<Either<FakeStoreFailure, List<Product>>> call() async {
    return _repository.getAllProducts();
  }
}
