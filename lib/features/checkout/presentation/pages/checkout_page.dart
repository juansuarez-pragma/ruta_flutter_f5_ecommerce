import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/core/utils/extensions.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_state.dart';
import 'package:ecommerce/features/checkout/presentation/bloc/checkout_bloc.dart';

/// Página de checkout.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CheckoutBloc>(),
      child: const _CheckoutPageContent(),
    );
  }
}

class _CheckoutPageContent extends StatelessWidget {
  const _CheckoutPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          // Recargar carrito y navegar a confirmación
          context.read<CartBloc>().add(const CartLoadRequested());
          Navigator.pushReplacementNamed(
            context,
            Routes.orderConfirmation,
            arguments: {'orderId': state.orderId},
          );
        } else if (state is CheckoutError) {
          context.showSnackBar(state.message, isError: true);
        }
      },
      child: Scaffold(
        appBar: const DSAppBar(title: 'Checkout'),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            if (cartState is! CartLoaded || cartState.isEmpty) {
              return const DSEmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'Carrito vacío',
                description: 'No hay productos para procesar',
              );
            }

            return BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, checkoutState) {
                final isProcessing = checkoutState is CheckoutProcessing;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(DSSpacing.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Resumen de productos
                          DSCard(
                            padding: const EdgeInsets.all(DSSpacing.base),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const DSText(
                                  'Resumen del pedido',
                                  variant: DSTextVariant.titleMedium,
                                ),
                                const SizedBox(height: DSSpacing.base),
                                ...cartState.items.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: DSSpacing.sm,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DSText(
                                            '${item.quantity}x ${item.product.title}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: DSSpacing.sm),
                                        DSText(item.totalPrice.toCurrency),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: DSSizes.borderHairline,
                                  color: context.tokens.colorBorderPrimary,
                                ),
                                const SizedBox(height: DSSpacing.sm),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const DSText(
                                      'Total',
                                      variant: DSTextVariant.titleMedium,
                                    ),
                                    DSText(
                                      cartState.totalPrice.toCurrency,
                                      variant: DSTextVariant.titleMedium,
                                      color: context.tokens.colorBrandPrimary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: DSSpacing.xl),

                          // Botón de confirmar
                          DSButton.primary(
                            text: 'Confirmar pedido',
                            isFullWidth: true,
                            isLoading: isProcessing,
                            onPressed: isProcessing
                                ? null
                                : () => context.read<CheckoutBloc>().add(
                                    CheckoutSubmitted(
                                      cartItems: cartState.items,
                                      totalPrice: cartState.totalPrice,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    if (isProcessing)
                      Container(
                        color: DSColors.blackAlpha32,
                        child: const Center(child: DSCircularLoader()),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
