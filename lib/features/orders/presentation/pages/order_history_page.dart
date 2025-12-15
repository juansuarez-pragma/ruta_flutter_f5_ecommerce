import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/config/app_config.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_history_bloc.dart';
import 'package:ecommerce/features/orders/presentation/widgets/order_card.dart';

/// Página de historial de órdenes.
///
/// Todos los textos de esta página vienen parametrizados desde el JSON.
class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appConfig = sl<AppConfig>();

    return BlocProvider(
      create: (_) =>
          sl<OrderHistoryBloc>()..add(const OrderHistoryLoadRequested()),
      child: Scaffold(
        // Título parametrizado desde JSON
        appBar: DSAppBar(title: appConfig.orderHistory.pageTitle),
        body: const _OrderHistoryBody(),
      ),
    );
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
            message: 'Cargando pedidos...',
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

/// Estado vacío con textos parametrizados.
class _EmptyOrderHistory extends StatelessWidget {
  const _EmptyOrderHistory({required this.config});
  final OrderHistoryConfig config;

  @override
  Widget build(BuildContext context) {
    // Todos los textos vienen del JSON
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

/// Lista de órdenes.
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
