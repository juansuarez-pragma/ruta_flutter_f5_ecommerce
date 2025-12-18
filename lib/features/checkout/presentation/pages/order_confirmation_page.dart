import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';

/// Order confirmation page.
class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final orderId = args?['orderId'] as String? ?? 'N/A';
    final tokens = context.tokens;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DSSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96, // Equivalent to avatarXxl not available in DS v1.1.0
                height: 96,
                decoration: BoxDecoration(
                  color: tokens.colorFeedbackSuccessLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: DSSizes.iconMega,
                  color: tokens.colorFeedbackSuccess,
                ),
              ),
              const SizedBox(height: DSSpacing.xl),
              const DSText(
                'Order confirmed!',
                variant: DSTextVariant.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DSSpacing.sm),
              DSText(
                'Your order has been processed successfully',
                color: tokens.colorTextSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DSSpacing.xl),
              DSCard(
                padding: const EdgeInsets.all(DSSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DSText('Order: ', color: tokens.colorTextSecondary),
                    DSText(orderId, variant: DSTextVariant.titleSmall),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.xxxl),
              DSButton.primary(
                text: 'Continue shopping',
                isFullWidth: true,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.home,
                  (route) => false,
                ),
              ),
              const SizedBox(height: DSSpacing.base),
              DSButton(
                text: 'View my orders',
                variant: DSButtonVariant.secondary,
                isFullWidth: true,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.orderHistory,
                  (route) => route.settings.name == Routes.home,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
