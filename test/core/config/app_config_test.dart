import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('stable public API: exposes config types', () {
      const currency = CurrencyConfig(symbol: r'$', decimalDigits: 2, locale: 'en_US');
      const settings = SettingsConfig(maxOrdersToShow: 10, dateFormat: 'dd/MM/yyyy', currency: currency);
      const images = ImagesConfig(
        emptyOrdersPlaceholder: 'assets/images/empty.png',
        orderSuccessIcon: 'assets/images/success.png',
      );
      const shippingInfo = ShippingInfoConfig(
        title: 'Shipping',
        freeShipping: 'Free',
        estimatedDelivery: '2-3 days',
      );
      const orderDetail = OrderDetailConfig(
        pageTitle: 'Details',
        sections: {'items': 'Items'},
        labels: {'total': 'Total'},
        shippingInfo: shippingInfo,
      );
      const emptyState = EmptyStateConfig(
        icon: 'box',
        title: 'No orders',
        description: 'You have no orders yet',
      );
      const orderCard = OrderCardConfig(
        orderLabel: 'Order',
        dateLabel: 'Date',
        totalLabel: 'Total',
        itemsLabel: 'Items',
        statusLabels: {'paid': 'Paid'},
      );
      const actions = ActionsConfig(viewDetails: 'View', reorder: 'Reorder');
      const orderHistory = OrderHistoryConfig(
        pageTitle: 'History',
        emptyState: emptyState,
        orderCard: orderCard,
        actions: actions,
      );

      const appConfig = AppConfig(
        orderHistory: orderHistory,
        orderDetail: orderDetail,
        images: images,
        settings: settings,
      );

      expect(appConfig.orderHistory.pageTitle, 'History');
      expect(appConfig.settings.currency.symbol, r'$');
    });

    test('fromJson parses the full tree correctly', () {
      final json = <String, dynamic>{
        'orderHistory': {
          'pageTitle': 'My orders',
          'emptyState': {
            'icon': 'box',
            'title': 'No orders',
            'description': 'You have not placed any orders yet',
          },
          'orderCard': {
            'orderLabel': 'Order',
            'dateLabel': 'Date',
            'totalLabel': 'Total',
            'itemsLabel': 'Items',
            'statusLabels': {'paid': 'Paid', 'pending': 'Pending'},
          },
          'actions': {'viewDetails': 'View details', 'reorder': 'Reorder'},
        },
        'orderDetail': {
          'pageTitle': 'Order details',
          'sections': {'items': 'Products', 'shipping': 'Shipping'},
          'labels': {'total': 'Total', 'date': 'Date'},
          'shippingInfo': {
            'title': 'Shipping information',
            'freeShipping': 'Free shipping',
            'estimatedDelivery': 'Estimated delivery',
          },
        },
        'images': {
          'emptyOrdersPlaceholder': 'assets/images/empty_orders.png',
          'orderSuccessIcon': 'assets/images/success.png',
        },
        'settings': {
          'maxOrdersToShow': 10,
          'dateFormat': 'dd/MM/yyyy',
          'currency': {'symbol': r'$', 'decimalDigits': 2, 'locale': 'en_US'},
        },
      };

      final config = AppConfig.fromJson(json);

      expect(config.orderHistory.pageTitle, 'My orders');
      expect(config.orderHistory.orderCard.getStatusLabel('paid'), 'Paid');
      expect(config.orderHistory.orderCard.getStatusLabel('unknown'), 'unknown');
      expect(config.orderDetail.shippingInfo.title, 'Shipping information');
      expect(config.images.orderSuccessIcon, 'assets/images/success.png');
      expect(config.settings.maxOrdersToShow, 10);
      expect(config.settings.currency.decimalDigits, 2);
    });
  });
}
