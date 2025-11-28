import 'package:equatable/equatable.dart';

/// Configuración de la aplicación parametrizada desde JSON.
///
/// Permite configurar textos, imágenes y ajustes sin modificar código.
class AppConfig extends Equatable {
  final OrderHistoryConfig orderHistory;
  final OrderDetailConfig orderDetail;
  final ImagesConfig images;
  final SettingsConfig settings;

  const AppConfig({
    required this.orderHistory,
    required this.orderDetail,
    required this.images,
    required this.settings,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      orderHistory: OrderHistoryConfig.fromJson(
        json['orderHistory'] as Map<String, dynamic>,
      ),
      orderDetail: OrderDetailConfig.fromJson(
        json['orderDetail'] as Map<String, dynamic>,
      ),
      images: ImagesConfig.fromJson(json['images'] as Map<String, dynamic>),
      settings: SettingsConfig.fromJson(
        json['settings'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  List<Object?> get props => [orderHistory, orderDetail, images, settings];
}

/// Configuración de la página de historial de órdenes.
class OrderHistoryConfig extends Equatable {
  final String pageTitle;
  final EmptyStateConfig emptyState;
  final OrderCardConfig orderCard;
  final ActionsConfig actions;

  const OrderHistoryConfig({
    required this.pageTitle,
    required this.emptyState,
    required this.orderCard,
    required this.actions,
  });

  factory OrderHistoryConfig.fromJson(Map<String, dynamic> json) {
    return OrderHistoryConfig(
      pageTitle: json['pageTitle'] as String,
      emptyState: EmptyStateConfig.fromJson(
        json['emptyState'] as Map<String, dynamic>,
      ),
      orderCard: OrderCardConfig.fromJson(
        json['orderCard'] as Map<String, dynamic>,
      ),
      actions: ActionsConfig.fromJson(json['actions'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [pageTitle, emptyState, orderCard, actions];
}

/// Configuración del estado vacío.
class EmptyStateConfig extends Equatable {
  final String icon;
  final String title;
  final String description;

  const EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory EmptyStateConfig.fromJson(Map<String, dynamic> json) {
    return EmptyStateConfig(
      icon: json['icon'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [icon, title, description];
}

/// Configuración de las tarjetas de orden.
class OrderCardConfig extends Equatable {
  final String orderLabel;
  final String dateLabel;
  final String totalLabel;
  final String itemsLabel;
  final Map<String, String> statusLabels;

  const OrderCardConfig({
    required this.orderLabel,
    required this.dateLabel,
    required this.totalLabel,
    required this.itemsLabel,
    required this.statusLabels,
  });

  factory OrderCardConfig.fromJson(Map<String, dynamic> json) {
    return OrderCardConfig(
      orderLabel: json['orderLabel'] as String,
      dateLabel: json['dateLabel'] as String,
      totalLabel: json['totalLabel'] as String,
      itemsLabel: json['itemsLabel'] as String,
      statusLabels: Map<String, String>.from(
        json['statusLabels'] as Map<String, dynamic>,
      ),
    );
  }

  String getStatusLabel(String status) {
    return statusLabels[status] ?? status;
  }

  @override
  List<Object?> get props => [
    orderLabel,
    dateLabel,
    totalLabel,
    itemsLabel,
    statusLabels,
  ];
}

/// Configuración de acciones.
class ActionsConfig extends Equatable {
  final String viewDetails;
  final String reorder;

  const ActionsConfig({required this.viewDetails, required this.reorder});

  factory ActionsConfig.fromJson(Map<String, dynamic> json) {
    return ActionsConfig(
      viewDetails: json['viewDetails'] as String,
      reorder: json['reorder'] as String,
    );
  }

  @override
  List<Object?> get props => [viewDetails, reorder];
}

/// Configuración de la página de detalle de orden.
class OrderDetailConfig extends Equatable {
  final String pageTitle;
  final Map<String, String> sections;
  final Map<String, String> labels;
  final ShippingInfoConfig shippingInfo;

  const OrderDetailConfig({
    required this.pageTitle,
    required this.sections,
    required this.labels,
    required this.shippingInfo,
  });

  factory OrderDetailConfig.fromJson(Map<String, dynamic> json) {
    return OrderDetailConfig(
      pageTitle: json['pageTitle'] as String,
      sections: Map<String, String>.from(
        json['sections'] as Map<String, dynamic>,
      ),
      labels: Map<String, String>.from(json['labels'] as Map<String, dynamic>),
      shippingInfo: ShippingInfoConfig.fromJson(
        json['shippingInfo'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  List<Object?> get props => [pageTitle, sections, labels, shippingInfo];
}

/// Configuración de información de envío.
class ShippingInfoConfig extends Equatable {
  final String title;
  final String freeShipping;
  final String estimatedDelivery;

  const ShippingInfoConfig({
    required this.title,
    required this.freeShipping,
    required this.estimatedDelivery,
  });

  factory ShippingInfoConfig.fromJson(Map<String, dynamic> json) {
    return ShippingInfoConfig(
      title: json['title'] as String,
      freeShipping: json['freeShipping'] as String,
      estimatedDelivery: json['estimatedDelivery'] as String,
    );
  }

  @override
  List<Object?> get props => [title, freeShipping, estimatedDelivery];
}

/// Configuración de imágenes.
class ImagesConfig extends Equatable {
  final String emptyOrdersPlaceholder;
  final String orderSuccessIcon;

  const ImagesConfig({
    required this.emptyOrdersPlaceholder,
    required this.orderSuccessIcon,
  });

  factory ImagesConfig.fromJson(Map<String, dynamic> json) {
    return ImagesConfig(
      emptyOrdersPlaceholder: json['emptyOrdersPlaceholder'] as String,
      orderSuccessIcon: json['orderSuccessIcon'] as String,
    );
  }

  @override
  List<Object?> get props => [emptyOrdersPlaceholder, orderSuccessIcon];
}

/// Configuración general de la aplicación.
class SettingsConfig extends Equatable {
  final int maxOrdersToShow;
  final String dateFormat;
  final CurrencyConfig currency;

  const SettingsConfig({
    required this.maxOrdersToShow,
    required this.dateFormat,
    required this.currency,
  });

  factory SettingsConfig.fromJson(Map<String, dynamic> json) {
    return SettingsConfig(
      maxOrdersToShow: json['maxOrdersToShow'] as int,
      dateFormat: json['dateFormat'] as String,
      currency: CurrencyConfig.fromJson(
        json['currency'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  List<Object?> get props => [maxOrdersToShow, dateFormat, currency];
}

/// Configuración de moneda.
class CurrencyConfig extends Equatable {
  final String symbol;
  final int decimalDigits;
  final String locale;

  const CurrencyConfig({
    required this.symbol,
    required this.decimalDigits,
    required this.locale,
  });

  factory CurrencyConfig.fromJson(Map<String, dynamic> json) {
    return CurrencyConfig(
      symbol: json['symbol'] as String,
      decimalDigits: json['decimalDigits'] as int,
      locale: json['locale'] as String,
    );
  }

  @override
  List<Object?> get props => [symbol, decimalDigits, locale];
}
