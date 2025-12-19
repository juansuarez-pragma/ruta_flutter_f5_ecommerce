import 'package:bloc_test/bloc_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/categories/presentation/bloc/categories_bloc.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late CategoriesBloc bloc;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    bloc = CategoriesBloc(getCategoriesUseCase: mockGetCategoriesUseCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  group('CategoriesBloc', () {
    test('initial state is CategoriesInitial', () {
      expect(bloc.state, const CategoriesInitial());
    });

    final categories = ProductFixtures.sampleCategories;

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [Loading, Loaded] when categories are loaded successfully',
      build: () {
        when(() => mockGetCategoriesUseCase())
            .thenAnswer((_) async => Right(categories));
        return bloc;
      },
      act: (bloc) => bloc.add(const CategoriesLoadRequested()),
      expect: () => [
        const CategoriesLoading(),
        CategoriesLoaded(categories),
      ],
      verify: (_) {
        verify(() => mockGetCategoriesUseCase()).called(1);
      },
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [Loading, Error] when use case returns a failure',
      build: () {
        when(() => mockGetCategoriesUseCase())
            .thenAnswer((_) async => const Left(ConnectionFailure('No internet')));
        return bloc;
      },
      act: (bloc) => bloc.add(const CategoriesLoadRequested()),
      expect: () => [
        const CategoriesLoading(),
        const CategoriesError('No internet'),
      ],
    );
  });
}
