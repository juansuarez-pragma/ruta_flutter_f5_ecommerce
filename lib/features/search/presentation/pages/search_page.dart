import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/constants/app_constants.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/features/search/presentation/bloc/search_bloc.dart';

/// Product search page.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(BuildContext context, String query) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSAppBar(
        titleWidget: DSTextField(
          controller: _searchController,
          hint: 'Search products...',
          prefixIcon: Icons.search,
          suffixIcon: Icons.clear,
          onSuffixIconTap: () {
            _searchController.clear();
            context.read<SearchBloc>().add(const SearchCleared());
          },
          onChanged: (value) => _onSearchChanged(context, value),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return switch (state) {
            SearchInitial() => const _EmptySearch(),
            SearchLoading() => const DSLoadingState(
              message: 'Searching...',
            ),
            SearchError(:final message) => DSErrorState(
              message: message,
              onRetry: () => context.read<SearchBloc>().add(
                SearchQueryChanged(_searchController.text),
              ),
            ),
            SearchLoaded(:final products, :final query) =>
              products.isEmpty
                  ? DSEmptyState(
                      icon: Icons.search_off,
                      title: 'No results',
                      description: 'No products found for "$query"',
                    )
                  : _SearchResults(products: products),
          };
        },
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: DSSizes.iconMega,
            color: tokens.colorTextTertiary,
          ),
          const SizedBox(height: DSSpacing.base),
          DSText(
            'Search products',
            variant: DSTextVariant.titleMedium,
            color: tokens.colorTextSecondary,
          ),
          const SizedBox(height: DSSpacing.sm),
          DSText(
            'Type to find what you are looking for',
            color: tokens.colorTextTertiary,
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.products});
  final List products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(DSSpacing.base),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: DSSpacing.sm,
        mainAxisSpacing: DSSpacing.sm,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return DSProductCard(
          imageUrl: product.image,
          title: product.title,
          price: product.price,
          rating: product.rating.rate,
          reviewCount: product.rating.count,
          onTap: () => Navigator.pushNamed(
            context,
            Routes.productDetailPath(product.id),
          ),
        );
      },
    );
  }
}
