import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/core/constants/app_constants.dart';
import 'package:ecommerce/features/home/presentation/bloc/home_bloc.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockGetProductsUseCase getProductsUseCase;
  late MockGetCategoriesUseCase getCategoriesUseCase;

  setUp(() {
    getProductsUseCase = MockGetProductsUseCase();
    getCategoriesUseCase = MockGetCategoriesUseCase();
  });

  HomeBloc buildBloc() => HomeBloc(
    getProductsUseCase: getProductsUseCase,
    getCategoriesUseCase: getCategoriesUseCase,
  );

  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when categories and products succeed',
      build: buildBloc,
      setUp: () {
        when(
          () => getCategoriesUseCase(),
        ).thenAnswer((_) async => Right(ProductFixtures.sampleCategories));
        when(
          () => getProductsUseCase(),
        ).thenAnswer((_) async => Right(ProductFixtures.sampleProducts));
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        isA<HomeLoaded>()
            .having((s) => s.categories, 'categories', ProductFixtures.sampleCategories)
            .having(
              (s) => s.featuredProducts.length,
              'featuredProducts length',
              lessThanOrEqualTo(AppConstants.featuredProductsLimit),
            ),
      ],
      verify: (_) {
        verify(() => getCategoriesUseCase()).called(1);
        verify(() => getProductsUseCase()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when categories fail',
      build: buildBloc,
      setUp: () {
        when(
          () => getCategoriesUseCase(),
        ).thenAnswer((_) async => const Left(ConnectionFailure()));
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        isA<HomeError>().having(
          (s) => s.message,
          'message',
          const ConnectionFailure().message,
        ),
      ],
      verify: (_) {
        verify(() => getCategoriesUseCase()).called(1);
        verifyNever(() => getProductsUseCase());
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when products fail',
      build: buildBloc,
      setUp: () {
        when(
          () => getCategoriesUseCase(),
        ).thenAnswer((_) async => Right(ProductFixtures.sampleCategories));
        when(
          () => getProductsUseCase(),
        ).thenAnswer((_) async => const Left(ServerFailure()));
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        isA<HomeError>().having(
          (s) => s.message,
          'message',
          const ServerFailure().message,
        ),
      ],
      verify: (_) {
        verify(() => getCategoriesUseCase()).called(1);
        verify(() => getProductsUseCase()).called(1);
      },
    );
  });
}

