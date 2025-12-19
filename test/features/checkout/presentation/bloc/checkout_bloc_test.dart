import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/core/utils/clock.dart';
import 'package:ecommerce/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';
import '../../../../helpers/mocks.dart';

class FakeClock implements Clock {
  FakeClock(this._now);
  final DateTime _now;

  @override
  DateTime now() => _now;
}

void main() {
  late CheckoutBloc bloc;
  late MockClearCartUseCase mockClearCartUseCase;
  late MockSaveOrderUseCase mockSaveOrderUseCase;

  setUpAll(() {
    registerFallbackValue(
      Order(
        id: 'ORD-0',
        items: const [],
        total: 0,
        createdAt: DateTime(2025),
      ),
    );
  });

  setUp(() {
    mockClearCartUseCase = MockClearCartUseCase();
    mockSaveOrderUseCase = MockSaveOrderUseCase();

    bloc = CheckoutBloc(
      clearCartUseCase: mockClearCartUseCase,
      saveOrderUseCase: mockSaveOrderUseCase,
      clock: FakeClock(DateTime.fromMillisecondsSinceEpoch(1000)),
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('CheckoutBloc', () {
    test('initial state is CheckoutInitial', () {
      expect(bloc.state, const CheckoutInitial());
    });

    blocTest<CheckoutBloc, CheckoutState>(
      'emits [Processing, Success] when checkout succeeds',
      build: () {
        when(() => mockSaveOrderUseCase(any())).thenAnswer((_) async {});
        when(() => mockClearCartUseCase()).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(
        CheckoutSubmitted(
          cartItems: CartItemFixtures.sampleCartItems,
          totalPrice: 100,
        ),
      ),
      wait: const Duration(seconds: 2),
      expect: () => [
        const CheckoutProcessing(),
        const CheckoutSuccess('ORD-1000'),
      ],
      verify: (_) {
        verify(() => mockSaveOrderUseCase(any())).called(1);
        verify(() => mockClearCartUseCase()).called(1);
      },
    );

    blocTest<CheckoutBloc, CheckoutState>(
      'emits [Processing, Error] when saving order throws',
      build: () {
        when(() => mockSaveOrderUseCase(any())).thenThrow(Exception('boom'));
        return bloc;
      },
      act: (bloc) => bloc.add(
        CheckoutSubmitted(
          cartItems: CartItemFixtures.sampleCartItems,
          totalPrice: 100,
        ),
      ),
      wait: const Duration(seconds: 2),
      expect: () => [
        const CheckoutProcessing(),
        isA<CheckoutError>(),
      ],
    );
  });
}
