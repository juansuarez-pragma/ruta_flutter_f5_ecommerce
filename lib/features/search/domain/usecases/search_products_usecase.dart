import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Caso de uso para buscar productos.
class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase({required ProductRepository repository})
      : _repository = repository;

  /// Ejecuta el caso de uso.
  ///
  /// Filtra los productos por título que contenga el query.
  Future<Either<FakeStoreFailure, List<Product>>> call(String query) async {
    final result = await _repository.getAllProducts();

    return result.fold((failure) => Left(failure), (products) {
      final filtered = products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return Right(filtered);
    });
  }
}
