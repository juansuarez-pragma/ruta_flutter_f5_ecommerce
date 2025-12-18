import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/shared/widgets/app_scaffold.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_state.dart';
import 'package:ecommerce/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:ecommerce/features/cart/presentation/widgets/cart_summary.dart';
import 'package:ecommerce/features/cart/presentation/widgets/empty_cart.dart';

/// Shopping cart page.
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
      title: 'Cart',
      currentIndex: 2,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return switch (state) {
            CartInitial() => const SizedBox.shrink(),
            CartLoading() => const DSLoadingState(
              message: 'Loading cart...',
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
