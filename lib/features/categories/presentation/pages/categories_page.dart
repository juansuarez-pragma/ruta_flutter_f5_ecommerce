import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/shared/widgets/app_scaffold.dart';
import 'package:ecommerce/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:ecommerce/features/categories/presentation/widgets/category_tile.dart';

/// Categories page.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CategoriesPageContent();
  }
}

class _CategoriesPageContent extends StatelessWidget {
  const _CategoriesPageContent();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Categories',
      currentIndex: 1,
      showBottomNav: false,
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          return switch (state) {
            CategoriesInitial() => const SizedBox.shrink(),
            CategoriesLoading() => const DSLoadingState(
              message: 'Loading categories...',
            ),
            CategoriesError(:final message) => DSErrorState(
              message: message,
              onRetry: () => context.read<CategoriesBloc>().add(
                const CategoriesLoadRequested(),
              ),
            ),
            CategoriesLoaded(:final categories) => ListView.separated(
              padding: const EdgeInsets.all(DSSpacing.base),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: DSSpacing.sm),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryTile(
                  category: category,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.products,
                    arguments: {'category': category},
                  ),
                );
              },
            ),
          };
        },
      ),
    );
  }
}
