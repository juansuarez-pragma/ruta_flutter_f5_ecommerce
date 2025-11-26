import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../../../core/utils/extensions.dart';

/// Resumen del carrito con subtotal, envío y total.
class CartSummary extends StatelessWidget {
  /// Subtotal del carrito.
  final double subtotal;

  /// Callback cuando se presiona el botón de checkout.
  final VoidCallback onCheckout;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    const shippingCost = 0.0; // Envío gratis
    final total = subtotal + shippingCost;

    return DSCard(
      padding: const EdgeInsets.all(DSSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRow(context, 'Subtotal', subtotal.toCurrency),
          const SizedBox(height: DSSpacing.sm),
          _buildRow(
            context,
            'Envío',
            shippingCost == 0 ? 'Gratis' : shippingCost.toCurrency,
            valueColor: tokens.colorFeedbackSuccess,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: DSSpacing.sm),
            child: Divider(),
          ),
          _buildRow(context, 'Total', total.toCurrency, isBold: true),
          const SizedBox(height: DSSpacing.base),
          DSButton.primary(
            text: 'Proceder al Checkout',
            onPressed: onCheckout,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    final tokens = context.tokens;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DSText(
          label,
          variant: isBold
              ? DSTextVariant.titleMedium
              : DSTextVariant.bodyMedium,
        ),
        DSText(
          value,
          variant: isBold
              ? DSTextVariant.titleMedium
              : DSTextVariant.bodyMedium,
          color: valueColor ?? (isBold ? tokens.colorBrandPrimary : null),
        ),
      ],
    );
  }
}
