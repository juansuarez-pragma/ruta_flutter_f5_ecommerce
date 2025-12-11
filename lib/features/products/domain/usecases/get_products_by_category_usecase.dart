import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener productos por categoría.
class GetProductsByCategoryUseCase {
  final ProductRepository _repository;

  GetProductsByCategoryUseCase({required ProductRepository repository})
      : _repository = repository;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, List<Product>>> call(String category) async {
    return _repository.getProductsByCategory(category);
  }
}
