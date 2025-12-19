import 'package:bloc_test/bloc_test.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/search/presentation/bloc/search_bloc.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late SearchBloc bloc;
  late MockSearchProductsUseCase mockSearchProductsUseCase;

  setUp(() {
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    bloc = SearchBloc(searchProductsUseCase: mockSearchProductsUseCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  group('SearchBloc', () {
    test('initial state is SearchInitial', () {
      expect(bloc.state, const SearchInitial());
    });

    final searchResults = ProductFixtures.sampleProducts;

    blocTest<SearchBloc, SearchState>(
      'emits [Initial] when query is empty',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchQueryChanged('')),
      expect: () => [const SearchInitial()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Loaded] when search succeeds',
      build: () {
        when(() => mockSearchProductsUseCase('test'))
            .thenAnswer((_) async => Right(searchResults));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('test')),
      expect: () => [
        const SearchLoading(),
        SearchLoaded(products: searchResults, query: 'test'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Loading, Error] when search fails',
      build: () {
        when(() => mockSearchProductsUseCase('test'))
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchQueryChanged('test')),
      expect: () => [
        const SearchLoading(),
        const SearchError('Server error'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [Initial] when cleared',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchCleared()),
      expect: () => [const SearchInitial()],
    );
  });
}
