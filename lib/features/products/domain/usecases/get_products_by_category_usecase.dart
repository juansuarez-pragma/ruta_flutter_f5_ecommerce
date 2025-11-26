import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para obtener productos por categoría.
class GetProductsByCategoryUseCase {
  final FakeStoreClient _client;

  GetProductsByCategoryUseCase({required FakeStoreClient client})
    : _client = client;

  /// Ejecuta el caso de uso.
  Future<Either<FakeStoreFailure, List<Product>>> call(String category) async {
    return _client.getProductsByCategory(category);
  }
}
