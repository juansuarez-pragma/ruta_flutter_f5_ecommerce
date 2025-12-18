import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/core/constants/app_constants.dart';

/// Home screen data.
class HomeData {
  const HomeData({required this.categories, required this.featuredProducts});
  final List<String> categories;
  final List<Product> featuredProducts;
}

/// Use case for retrieving home screen data.
class GetHomeDataUseCase {
  GetHomeDataUseCase({required ProductRepository repository})
    : _repository = repository;
  final ProductRepository _repository;

  /// Executes the use case.
  Future<Either<FakeStoreFailure, HomeData>> call() async {
    // Fetch categories
    final categoriesResult = await _repository.getAllCategories();

    return categoriesResult.fold((failure) => Left(failure), (
      categories,
    ) async {
      // Fetch products
      final productsResult = await _repository.getAllProducts();

      return productsResult.fold((failure) => Left(failure), (products) {
        // Limit to featured products
        final featured = products
            .take(AppConstants.featuredProductsLimit)
            .toList();

        return Right(
          HomeData(categories: categories, featuredProducts: featured),
        );
      });
    });
  }
}
