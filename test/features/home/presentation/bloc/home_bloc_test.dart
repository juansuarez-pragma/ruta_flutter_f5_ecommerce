import 'package:bloc_test/bloc_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/core/constants/app_constants.dart';
import 'package:ecommerce/features/home/presentation/bloc/home_bloc.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late HomeBloc bloc;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    bloc = HomeBloc(
      getProductsUseCase: mockGetProductsUseCase,
      getCategoriesUseCase: mockGetCategoriesUseCase,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('HomeBloc', () {
    test('initial state is HomeInitial', () {
      expect(bloc.state, const HomeInitial());
    });

    blocTest<HomeBloc, HomeState>(
      'emits [Loading, Loaded] with featured products when both calls succeed',
      build: () {
        final categories = ProductFixtures.sampleCategories;
        when(() => mockGetCategoriesUseCase())
            .thenAnswer((_) async => Right(categories));

        final products = List.generate(
          AppConstants.featuredProductsLimit + 1,
          (i) => Product(
            id: i + 1,
            title: 'Product $i',
            price: 10,
            description: 'Description $i',
            category: 'electronics',
            image: 'https://example.com/image_$i.jpg',
            rating: const ProductRating(rate: 4.5, count: 100),
          ),
        );

        when(() => mockGetProductsUseCase()).thenAnswer((_) async => Right(products));
        return bloc;
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        isA<HomeLoaded>()
            .having((s) => s.categories, 'categories', isA<List<String>>())
            .having(
              (s) => s.featuredProducts.length,
              'featuredProducts.length',
              AppConstants.featuredProductsLimit,
            ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [Loading, Error] when categories call fails',
      build: () {
        when(() => mockGetCategoriesUseCase())
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        const HomeError('Server error'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [Loading, Error] when products call fails',
      build: () {
        final categories = ProductFixtures.sampleCategories;
        when(() => mockGetCategoriesUseCase())
            .thenAnswer((_) async => Right(categories));
        when(() => mockGetProductsUseCase())
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        const HomeError('Server error'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'refresh triggers a new load request',
      build: () {
        final categories = ProductFixtures.sampleCategories;
        final products = ProductFixtures.sampleProducts;
        when(() => mockGetCategoriesUseCase()).thenAnswer((_) async => Right(categories));
        when(() => mockGetProductsUseCase()).thenAnswer((_) async => Right(products));
        return bloc;
      },
      act: (bloc) => bloc.add(const HomeRefreshRequested()),
      expect: () => [
        const HomeLoading(),
        isA<HomeLoaded>(),
      ],
    );
  });
}
