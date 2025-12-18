import 'package:fake_store_api_client/fake_store_api_client.dart';

/// Use case for searching products.
class SearchProductsUseCase {
  SearchProductsUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Executes the use case.
  ///
  /// Filters products whose title contains the query.
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
