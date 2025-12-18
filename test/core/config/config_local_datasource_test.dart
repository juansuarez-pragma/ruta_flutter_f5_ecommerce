import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/core/config/asset_string_loader.dart';
import 'package:ecommerce/core/config/config_local_datasource.dart';

class MockAssetStringLoader extends Mock implements AssetStringLoader {}

void main() {
  late MockAssetStringLoader mockAssetLoader;
  late ConfigLocalDataSource dataSource;

  setUp(() {
    mockAssetLoader = MockAssetStringLoader();
    dataSource = ConfigLocalDataSource(assetLoader: mockAssetLoader);
  });

  group('ConfigLocalDataSource', () {
    test('should load and parse config JSON from assets', () async {
      final jsonMap = <String, dynamic>{
        'orderHistory': {
          'pageTitle': 'Order History',
          'emptyState': {
            'icon': 'box',
            'title': 'No orders',
            'description': 'You have no orders yet',
          },
          'orderCard': {
            'orderLabel': 'Order',
            'dateLabel': 'Date',
            'totalLabel': 'Total',
            'itemsLabel': 'Items',
            'statusLabels': {'paid': 'Paid'},
          },
          'actions': {'viewDetails': 'View', 'reorder': 'Reorder'},
        },
        'orderDetail': {
          'pageTitle': 'Order Detail',
          'sections': {'items': 'Products'},
          'labels': {'total': 'Total'},
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

      when(() => mockAssetLoader.loadString(any()))
          .thenAnswer((_) async => json.encode(jsonMap));

      final config = await dataSource.loadConfig();

      expect(config.orderHistory.pageTitle, 'Order History');
      expect(config.settings.currency.symbol, r'$');
      verify(() => mockAssetLoader.loadString(any())).called(1);
    });

    test('should cache the loaded config and avoid reading twice', () async {
      final jsonMap = <String, dynamic>{
        'orderHistory': {
          'pageTitle': 'Order History',
          'emptyState': {
            'icon': 'box',
            'title': 'No orders',
            'description': 'You have no orders yet',
          },
          'orderCard': {
            'orderLabel': 'Order',
            'dateLabel': 'Date',
            'totalLabel': 'Total',
            'itemsLabel': 'Items',
            'statusLabels': {'paid': 'Paid'},
          },
          'actions': {'viewDetails': 'View', 'reorder': 'Reorder'},
        },
        'orderDetail': {
          'pageTitle': 'Order Detail',
          'sections': {'items': 'Products'},
          'labels': {'total': 'Total'},
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

      when(() => mockAssetLoader.loadString(any()))
          .thenAnswer((_) async => json.encode(jsonMap));

      final first = await dataSource.loadConfig();
      final second = await dataSource.loadConfig();

      expect(identical(first, second), isTrue);
      verify(() => mockAssetLoader.loadString(any())).called(1);
    });
  });
}
