import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/config/models/order_history_config.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_history_bloc.dart';
import 'package:ecommerce/features/orders/presentation/widgets/order_card.dart';

/// Order history page.
///
/// All texts for this page are driven by JSON configuration.
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSAppBar(title: _resolveTitle(context)),
      body: const _OrderHistoryBody(),
    );
  }

  String _resolveTitle(BuildContext context) {
    final state = context.watch<OrderHistoryBloc>().state;
    if (state is OrderHistoryLoaded) {
      return state.config.pageTitle;
    }

    if (state is OrderHistoryError) {
      return 'Orders';
    }

    if (state is OrderHistoryLoading) {
      return 'Loading...';
    }

    return 'Orders';
  }
}

class _OrderHistoryBody extends StatelessWidget {
  const _OrderHistoryBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
      builder: (context, state) {
        return switch (state) {
          OrderHistoryInitial() => const SizedBox.shrink(),
          OrderHistoryLoading() => const DSLoadingState(
            message: 'Loading orders...',
          ),
          OrderHistoryError(:final message) => DSErrorState(
            message: message,
            onRetry: () => context.read<OrderHistoryBloc>().add(
              const OrderHistoryLoadRequested(),
            ),
          ),
          OrderHistoryLoaded(:final orders, :final config) =>
            orders.isEmpty
                ? _EmptyOrderHistory(config: config)
                : _OrdersList(state: state),
        };
      },
    );
  }
}

/// Empty state with JSON-driven texts.
class _EmptyOrderHistory extends StatelessWidget {
  const _EmptyOrderHistory({required this.config});
  final OrderHistoryConfig config;

  @override
  Widget build(BuildContext context) {
    // All texts come from JSON configuration.
    return DSEmptyState(
      icon: _getIconFromString(config.emptyState.icon),
      title: config.emptyState.title,
      description: config.emptyState.description,
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'receipt_long':
        return Icons.receipt_long;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'history':
        return Icons.history;
      default:
        return Icons.receipt_long;
    }
  }
}

/// Orders list.
class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.state});
  final OrderHistoryLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderHistoryBloc>().add(
          const OrderHistoryRefreshRequested(),
        );
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(DSSpacing.base),
        itemCount: state.orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: DSSpacing.sm),
        itemBuilder: (context, index) {
          final order = state.orders[index];
          return OrderCard(order: order, config: state.config);
        },
      ),
    );
  }
}
