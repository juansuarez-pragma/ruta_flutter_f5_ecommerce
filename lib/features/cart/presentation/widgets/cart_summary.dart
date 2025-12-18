import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/utils/extensions.dart';

/// Cart summary with subtotal, shipping, and total.
class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.subtotal,
    required this.onCheckout,
  });

  /// Cart subtotal.
  final double subtotal;

  /// Callback invoked when the checkout button is pressed.
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    const shippingCost = 0.0; // Free shipping
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
            'Shipping',
            shippingCost == 0 ? 'Free' : shippingCost.toCurrency,
            valueColor: tokens.colorFeedbackSuccess,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: DSSpacing.sm),
            child: Container(
              height: DSSizes.borderHairline,
              color: tokens.colorBorderPrimary,
            ),
          ),
          _buildRow(context, 'Total', total.toCurrency, isBold: true),
          const SizedBox(height: DSSpacing.base),
          DSButton.primary(
            text: 'Proceed to checkout',
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
