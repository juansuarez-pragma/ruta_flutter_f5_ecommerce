import 'package:bloc_test/bloc_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/products/presentation/bloc/product_detail_bloc.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late ProductDetailBloc bloc;
  late MockGetProductByIdUseCase mockGetProductByIdUseCase;

  setUp(() {
    mockGetProductByIdUseCase = MockGetProductByIdUseCase();
    bloc = ProductDetailBloc(getProductByIdUseCase: mockGetProductByIdUseCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  group('ProductDetailBloc', () {
    test('initial state is ProductDetailInitial', () {
      expect(bloc.state, const ProductDetailInitial());
    });

    blocTest<ProductDetailBloc, ProductDetailState>(
      'emits [Loading, Loaded] when product is loaded successfully',
      build: () {
        when(() => mockGetProductByIdUseCase(1))
            .thenAnswer((_) async => Right(ProductFixtures.sampleProduct));
        return bloc;
      },
      act: (bloc) => bloc.add(const ProductDetailLoadRequested(1)),
      expect: () => [
        const ProductDetailLoading(),
        ProductDetailLoaded(ProductFixtures.sampleProduct),
      ],
      verify: (_) {
        verify(() => mockGetProductByIdUseCase(1)).called(1);
      },
    );

    blocTest<ProductDetailBloc, ProductDetailState>(
      'emits [Loading, Error] when use case returns a failure',
      build: () {
        when(() => mockGetProductByIdUseCase(1))
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const ProductDetailLoadRequested(1)),
      expect: () => [
        const ProductDetailLoading(),
        const ProductDetailError('Server error'),
      ],
    );
  });
}
