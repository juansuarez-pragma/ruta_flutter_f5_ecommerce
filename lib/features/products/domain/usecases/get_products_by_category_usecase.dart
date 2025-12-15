import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener productos por categoría.
class GetProductsByCategoryUseCase {
  GetProductsByCategoryUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, List<Product>>> call(String category) async {
    return _repository.getProductsByCategory(category);
  }
}
