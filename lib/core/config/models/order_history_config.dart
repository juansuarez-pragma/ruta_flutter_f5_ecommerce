import 'package:equatable/equatable.dart';

import 'package:ecommerce/core/config/models/actions_config.dart';
import 'package:ecommerce/core/config/models/empty_state_config.dart';
import 'package:ecommerce/core/config/models/order_card_config.dart';

/// Configuración de la página de historial de órdenes.
class OrderHistoryConfig extends Equatable {
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

  final String pageTitle;
  final EmptyStateConfig emptyState;
  final OrderCardConfig orderCard;
  final ActionsConfig actions;

  @override
  List<Object?> get props => [pageTitle, emptyState, orderCard, actions];
}

