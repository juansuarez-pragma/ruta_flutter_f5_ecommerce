import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_state.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late CartBloc cartBloc;
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockRemoveFromCartUseCase mockRemoveFromCartUseCase;
  late MockUpdateCartQuantityUseCase mockUpdateCartQuantityUseCase;
  late MockClearCartUseCase mockClearCartUseCase;

  setUpAll(() {
    registerFallbackValue(CartItemFixtures.sampleCartItem);
  });

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockRemoveFromCartUseCase = MockRemoveFromCartUseCase();
    mockUpdateCartQuantityUseCase = MockUpdateCartQuantityUseCase();
    mockClearCartUseCase = MockClearCartUseCase();

    cartBloc = CartBloc(
      getCartUseCase: mockGetCartUseCase,
      addToCartUseCase: mockAddToCartUseCase,
      removeFromCartUseCase: mockRemoveFromCartUseCase,
      updateQuantityUseCase: mockUpdateCartQuantityUseCase,
      clearCartUseCase: mockClearCartUseCase,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    test('initial state is CartInitial', () {
      expect(cartBloc.state, const CartInitial());
    });

    group('CartLoadRequested', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] when load is successful',
        build: () {
          when(
            () => mockGetCartUseCase(),
          ).thenAnswer((_) async => CartItemFixtures.sampleCartItems);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const CartLoadRequested()),
        expect: () => [
          const CartLoading(),
          CartLoaded(items: CartItemFixtures.sampleCartItems),
        ],
        verify: (_) {
          verify(() => mockGetCartUseCase()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] with empty list when cart is empty',
        build: () {
          when(() => mockGetCartUseCase()).thenAnswer((_) async => []);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const CartLoadRequested()),
        expect: () => [const CartLoading(), const CartLoaded(items: [])],
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartError] when load fails',
        build: () {
          when(
            () => mockGetCartUseCase(),
          ).thenThrow(Exception('Storage error'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const CartLoadRequested()),
        expect: () => [const CartLoading(), isA<CartError>()],
      );
    });

    group('CartItemAdded', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] when item is added successfully',
        build: () {
          when(() => mockAddToCartUseCase(any())).thenAnswer((_) async {});
          when(
            () => mockGetCartUseCase(),
          ).thenAnswer((_) async => CartItemFixtures.sampleCartItems);
          return cartBloc;
        },
        act: (bloc) =>
            bloc.add(CartItemAdded(product: ProductFixtures.sampleProduct)),
        expect: () => [CartLoaded(items: CartItemFixtures.sampleCartItems)],
        verify: (_) {
          verify(() => mockAddToCartUseCase(any())).called(1);
          verify(() => mockGetCartUseCase()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when adding item fails',
        build: () {
          when(
            () => mockAddToCartUseCase(any()),
          ).thenThrow(Exception('Add error'));
          return cartBloc;
        },
        act: (bloc) =>
            bloc.add(CartItemAdded(product: ProductFixtures.sampleProduct)),
        expect: () => [isA<CartError>()],
      );
    });

    group('CartItemRemoved', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] when item is removed successfully',
        build: () {
          when(() => mockRemoveFromCartUseCase(any())).thenAnswer((_) async {});
          when(() => mockGetCartUseCase()).thenAnswer((_) async => []);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const CartItemRemoved(1)),
        expect: () => [const CartLoaded(items: [])],
        verify: (_) {
          verify(() => mockRemoveFromCartUseCase(1)).called(1);
          verify(() => mockGetCartUseCase()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when removing item fails',
        build: () {
          when(
            () => mockRemoveFromCartUseCase(any()),
          ).thenThrow(Exception('Remove error'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const CartItemRemoved(1)),
        expect: () => [isA<CartError>()],
      );
    });

    group('CartItemQuantityUpdated', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] when quantity is updated successfully',
        build: () {
          when(
            () => mockUpdateCartQuantityUseCase(any(), any()),
          ).thenAnswer((_) async {});
          when(
            () => mockGetCartUseCase(),
          ).thenAnswer((_) async => CartItemFixtures.sampleCartItems);
          return cartBloc;
        },
        act: (bloc) =>
            bloc.add(const CartItemQuantityUpdated(productId: 1, quantity: 5)),
        expect: () => [CartLoaded(items: CartItemFixtures.sampleCartItems)],
        verify: (_) {
          verify(() => mockUpdateCartQuantityUseCase(1, 5)).called(1);
          verify(() => mockGetCartUseCase()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when updating quantity fails',
        build: () {
          when(
            () => mockUpdateCartQuantityUseCase(any(), any()),
          ).thenThrow(Exception('Update error'));
          return cartBloc;
        },
        act: (bloc) =>
            bloc.add(const CartItemQuantityUpdated(productId: 1, quantity: 5)),
        expect: () => [isA<CartError>()],
      );
    });

    group('CartCleared', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] with empty items when cart is cleared',
        build: () {
          when(() => mockClearCartUseCase()).thenAnswer((_) async {});
          return cartBloc;
        },
        act: (bloc) => bloc.add(const CartCleared()),
        expect: () => [const CartLoaded(items: [])],
        verify: (_) {
          verify(() => mockClearCartUseCase()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when clearing cart fails',
        build: () {
          when(
            () => mockClearCartUseCase(),
          ).thenThrow(Exception('Clear error'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const CartCleared()),
        expect: () => [isA<CartError>()],
      );
    });
  });

  group('CartLoaded State', () {
    test('totalItems calculates correctly', () {
      final state = CartLoaded(items: CartItemFixtures.sampleCartItems);
      // 2 + 1 = 3 total items
      expect(state.totalItems, 3);
    });

    test('totalPrice calculates correctly', () {
      final state = CartLoaded(items: CartItemFixtures.sampleCartItems);
      // (99.99 * 2) + (49.99 * 1) = 199.98 + 49.99 = 249.97
      expect(state.totalPrice, closeTo(249.97, 0.01));
    });

    test('isEmpty returns true when no items', () {
      const state = CartLoaded(items: []);
      expect(state.isEmpty, true);
    });

    test('isEmpty returns false when has items', () {
      final state = CartLoaded(items: CartItemFixtures.sampleCartItems);
      expect(state.isEmpty, false);
    });
  });
}
