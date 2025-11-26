import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/product_grid.dart';

/// Página de listado de productos.
class ProductsPage extends StatelessWidget {
  /// Categoría opcional para filtrar productos.
  final String? category;

  const ProductsPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProductsBloc>()..add(ProductsLoadRequested(category: category)),
      child: _ProductsPageContent(category: category),
    );
  }
}

class _ProductsPageContent extends StatelessWidget {
  final String? category;

  const _ProductsPageContent({this.category});

  @override
  Widget build(BuildContext context) {
    final title = category?.titleCase ?? 'Todos los Productos';

    return AppScaffold(
      title: title,
      currentIndex: 1,
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          return switch (state) {
            ProductsInitial() => const SizedBox.shrink(),
            ProductsLoading() => const DSLoadingState(
              message: 'Cargando productos...',
            ),
            ProductsError(:final message) => DSErrorState(
              message: message,
              onRetry: () => context.read<ProductsBloc>().add(
                ProductsLoadRequested(category: category),
              ),
            ),
            ProductsLoaded(:final products) =>
              products.isEmpty
                  ? const DSEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Sin productos',
                      description: 'No hay productos disponibles',
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProductsBloc>().add(
                          const ProductsRefreshRequested(),
                        );
                      },
                      child: ProductGrid(products: products),
                    ),
          };
        },
      ),
    );
  }
}
