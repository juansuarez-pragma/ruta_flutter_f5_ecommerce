import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('API pública estable: expone tipos de config', () {
      const currency = CurrencyConfig(symbol: r'$', decimalDigits: 2, locale: 'en_US');
      const settings = SettingsConfig(maxOrdersToShow: 10, dateFormat: 'dd/MM/yyyy', currency: currency);
      const images = ImagesConfig(
        emptyOrdersPlaceholder: 'assets/images/empty.png',
        orderSuccessIcon: 'assets/images/success.png',
      );
      const shippingInfo = ShippingInfoConfig(
        title: 'Envío',
        freeShipping: 'Gratis',
        estimatedDelivery: '2-3 días',
      );
      const orderDetail = OrderDetailConfig(
        pageTitle: 'Detalle',
        sections: {'items': 'Items'},
        labels: {'total': 'Total'},
        shippingInfo: shippingInfo,
      );
      const emptyState = EmptyStateConfig(
        icon: 'box',
        title: 'Sin órdenes',
        description: 'Aún no tienes órdenes',
      );
      const orderCard = OrderCardConfig(
        orderLabel: 'Orden',
        dateLabel: 'Fecha',
        totalLabel: 'Total',
        itemsLabel: 'Items',
        statusLabels: {'paid': 'Pagado'},
      );
      const actions = ActionsConfig(viewDetails: 'Ver', reorder: 'Reordenar');
      const orderHistory = OrderHistoryConfig(
        pageTitle: 'Historial',
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

      expect(appConfig.orderHistory.pageTitle, 'Historial');
      expect(appConfig.settings.currency.symbol, r'$');
    });

    test('fromJson parsea el árbol completo correctamente', () {
      final json = <String, dynamic>{
        'orderHistory': {
          'pageTitle': 'Mis órdenes',
          'emptyState': {
            'icon': 'box',
            'title': 'No hay órdenes',
            'description': 'Aún no realizas compras',
          },
          'orderCard': {
            'orderLabel': 'Orden',
            'dateLabel': 'Fecha',
            'totalLabel': 'Total',
            'itemsLabel': 'Items',
            'statusLabels': {'paid': 'Pagado', 'pending': 'Pendiente'},
          },
          'actions': {'viewDetails': 'Ver detalle', 'reorder': 'Comprar de nuevo'},
        },
        'orderDetail': {
          'pageTitle': 'Detalle de orden',
          'sections': {'items': 'Productos', 'shipping': 'Envío'},
          'labels': {'total': 'Total', 'date': 'Fecha'},
          'shippingInfo': {
            'title': 'Información de envío',
            'freeShipping': 'Envío gratis',
            'estimatedDelivery': 'Entrega estimada',
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

      expect(config.orderHistory.pageTitle, 'Mis órdenes');
      expect(config.orderHistory.orderCard.getStatusLabel('paid'), 'Pagado');
      expect(config.orderHistory.orderCard.getStatusLabel('unknown'), 'unknown');
      expect(config.orderDetail.shippingInfo.title, 'Información de envío');
      expect(config.images.orderSuccessIcon, 'assets/images/success.png');
      expect(config.settings.maxOrdersToShow, 10);
      expect(config.settings.currency.decimalDigits, 2);
    });
  });
}

