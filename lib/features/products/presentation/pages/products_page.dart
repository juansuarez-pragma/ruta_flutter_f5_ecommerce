import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/utils/extensions.dart';
import 'package:ecommerce/shared/widgets/app_scaffold.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_event.dart';
import 'package:ecommerce/features/products/presentation/bloc/products_state.dart';
import 'package:ecommerce/features/products/presentation/widgets/product_grid.dart';

/// Products list page.
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key, this.category});

  /// Optional category to filter products.
  final String? category;

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
  const _ProductsPageContent({this.category});
  final String? category;

  @override
  Widget build(BuildContext context) {
    final title = category?.titleCase ?? 'All products';

    return AppScaffold(
      title: title,
      currentIndex: 1,
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          return switch (state) {
            ProductsInitial() => const SizedBox.shrink(),
            ProductsLoading() => const DSLoadingState(
              message: 'Loading products...',
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
                      title: 'No products',
                      description: 'There are no available products',
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
