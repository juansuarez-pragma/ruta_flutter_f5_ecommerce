import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/routes.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';
import '../widgets/empty_cart.dart';

/// Página del carrito de compras.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartBloc>()..add(const CartLoadRequested()),
      child: const _CartPageContent(),
    );
  }
}

class _CartPageContent extends StatelessWidget {
  const _CartPageContent();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Carrito',
      currentIndex: 2,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return switch (state) {
            CartInitial() => const SizedBox.shrink(),
            CartLoading() => const DSLoadingState(
              message: 'Cargando carrito...',
            ),
            CartError(:final message) => DSErrorState(
              message: message,
              onRetry: () =>
                  context.read<CartBloc>().add(const CartLoadRequested()),
            ),
            CartLoaded(:final items) =>
              items.isEmpty
                  ? const EmptyCart()
                  : _buildCartContent(context, state),
          };
        },
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(DSSpacing.base),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: DSSpacing.sm),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartItemTile(
                item: item,
                onQuantityChanged: (quantity) {
                  context.read<CartBloc>().add(
                    CartItemQuantityUpdated(
                      productId: item.product.id,
                      quantity: quantity,
                    ),
                  );
                },
                onRemove: () {
                  context.read<CartBloc>().add(
                    CartItemRemoved(item.product.id),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(DSSpacing.base),
          child: CartSummary(
            subtotal: state.totalPrice,
            onCheckout: () => Navigator.pushNamed(context, Routes.checkout),
          ),
        ),
      ],
    );
  }
}
