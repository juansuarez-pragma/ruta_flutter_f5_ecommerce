import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/config/app_config.dart';
import 'package:ecommerce/core/utils/extensions.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';

/// Tarjeta de orden con textos parametrizados desde JSON.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.config});
  final Order order;
  final OrderHistoryConfig config;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DSCard(
      padding: const EdgeInsets.all(DSSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ID y Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label parametrizado desde JSON
              DSText(
                '${config.orderCard.orderLabel} #${order.id.split('-').last}',
                variant: DSTextVariant.titleSmall,
              ),
              // Estado con label parametrizado
              DSBadge(
                text: config.orderCard.getStatusLabel(order.status.key),
                type: _getBadgeType(order.status),
              ),
            ],
          ),
          const SizedBox(height: DSSpacing.sm),

          // Fecha - Label parametrizado
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: DSSizes.iconSm,
                color: tokens.colorIconSecondary,
              ),
              const SizedBox(width: DSSpacing.xs),
              DSText(
                '${config.orderCard.dateLabel}: ${_formatDate(order.createdAt)}',
                variant: DSTextVariant.bodySmall,
                color: tokens.colorTextSecondary,
              ),
            ],
          ),
          const SizedBox(height: DSSpacing.xs),

          // Productos - Label parametrizado
          Row(
            children: [
              Icon(
                Icons.shopping_bag,
                size: DSSizes.iconSm,
                color: tokens.colorIconSecondary,
              ),
              const SizedBox(width: DSSpacing.xs),
              DSText(
                '${order.totalItems} ${config.orderCard.itemsLabel}',
                variant: DSTextVariant.bodySmall,
                color: tokens.colorTextSecondary,
              ),
            ],
          ),
          const SizedBox(height: DSSpacing.base),

          // Divider
          Container(
            height: DSSizes.borderHairline,
            color: tokens.colorBorderPrimary,
          ),
          const SizedBox(height: DSSpacing.base),

          // Total - Label parametrizado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DSText(
                config.orderCard.totalLabel,
                variant: DSTextVariant.titleSmall,
              ),
              DSText(
                order.total.toCurrency,
                variant: DSTextVariant.titleMedium,
                color: tokens.colorBrandPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  DSBadgeType _getBadgeType(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return DSBadgeType.success;
      case OrderStatus.pending:
        return DSBadgeType.warning;
      case OrderStatus.cancelled:
        return DSBadgeType.error;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
