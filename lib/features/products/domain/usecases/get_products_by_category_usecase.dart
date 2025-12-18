import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Use case for retrieving products by category.
class GetProductsByCategoryUseCase {
  GetProductsByCategoryUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Executes the use case.
  Future<Either<FakeStoreFailure, List<Product>>> call(String category) async {
    return _repository.getProductsByCategory(category);
  }
}
