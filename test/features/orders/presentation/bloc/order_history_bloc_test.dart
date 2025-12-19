import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/core/config/app_config.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_history_bloc.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late OrderHistoryBloc bloc;
  late MockGetOrdersUseCase mockGetOrdersUseCase;

  const appConfig = AppConfig(
    orderHistory: OrderHistoryConfig(
      pageTitle: 'Orders',
      emptyState: EmptyStateConfig(
        icon: 'box',
        title: 'No orders',
        description: 'You have no orders yet',
      ),
      orderCard: OrderCardConfig(
        orderLabel: 'Order',
        dateLabel: 'Date',
        totalLabel: 'Total',
        itemsLabel: 'Items',
        statusLabels: {'paid': 'Paid'},
      ),
      actions: ActionsConfig(viewDetails: 'View', reorder: 'Reorder'),
    ),
    orderDetail: OrderDetailConfig(
      pageTitle: 'Details',
      sections: {'items': 'Items'},
      labels: {'total': 'Total'},
      shippingInfo: ShippingInfoConfig(
        title: 'Shipping',
        freeShipping: 'Free',
        estimatedDelivery: '2-3 days',
      ),
    ),
    images: ImagesConfig(
      emptyOrdersPlaceholder: 'assets/images/empty.png',
      orderSuccessIcon: 'assets/images/success.png',
    ),
    settings: SettingsConfig(
      maxOrdersToShow: 10,
      dateFormat: 'dd/MM/yyyy',
      currency: CurrencyConfig(symbol: r'$', decimalDigits: 2, locale: 'en_US'),
    ),
  );

  final order = Order(
    id: '1',
    items: const [],
    total: 10,
    createdAt: DateTime(2025),
  );

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    bloc = OrderHistoryBloc(
      getOrdersUseCase: mockGetOrdersUseCase,
      appConfig: appConfig,
    );
  });

  tearDown(() async {
    await bloc.close();
  });

  group('OrderHistoryBloc', () {
    test('initial state is OrderHistoryInitial', () {
      expect(bloc.state, const OrderHistoryInitial());
    });

    blocTest<OrderHistoryBloc, OrderHistoryState>(
      'emits [Loading, Loaded] when orders load successfully',
      build: () {
        when(() => mockGetOrdersUseCase()).thenAnswer((_) async => [order]);
        return bloc;
      },
      act: (bloc) => bloc.add(const OrderHistoryLoadRequested()),
      expect: () => [
        const OrderHistoryLoading(),
        OrderHistoryLoaded(orders: [order], config: appConfig.orderHistory),
      ],
    );

    blocTest<OrderHistoryBloc, OrderHistoryState>(
      'emits [Loading, Error] when use case throws',
      build: () {
        when(() => mockGetOrdersUseCase()).thenThrow(Exception('boom'));
        return bloc;
      },
      act: (bloc) => bloc.add(const OrderHistoryLoadRequested()),
      expect: () => [
        const OrderHistoryLoading(),
        isA<OrderHistoryError>(),
      ],
    );
  });
}

