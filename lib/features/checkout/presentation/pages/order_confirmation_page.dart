import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';

/// Página de confirmación de orden.
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
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: tokens.colorFeedbackSuccess.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: tokens.colorFeedbackSuccess,
                ),
              ),
              const SizedBox(height: DSSpacing.xl),
              const DSText(
                '¡Pedido confirmado!',
                variant: DSTextVariant.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DSSpacing.sm),
              DSText(
                'Tu pedido ha sido procesado exitosamente',
                variant: DSTextVariant.bodyMedium,
                color: tokens.colorTextSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DSSpacing.xl),
              DSCard(
                padding: const EdgeInsets.all(DSSpacing.base),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DSText(
                      'Orden: ',
                      variant: DSTextVariant.bodyMedium,
                      color: tokens.colorTextSecondary,
                    ),
                    DSText(orderId, variant: DSTextVariant.titleSmall),
                  ],
                ),
              ),
              const SizedBox(height: DSSpacing.xxxl),
              DSButton.primary(
                text: 'Seguir comprando',
                isFullWidth: true,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.home,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
