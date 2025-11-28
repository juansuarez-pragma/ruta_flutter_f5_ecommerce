import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/shared/widgets/app_scaffold.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_state.dart';
import 'package:ecommerce/features/home/presentation/bloc/home_bloc.dart';
import 'package:ecommerce/features/home/presentation/widgets/categories_section.dart';
import 'package:ecommerce/features/home/presentation/widgets/featured_products_section.dart';

/// Página principal del home.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeLoadRequested()),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              title: const DSText(
                'Fake Store',
                variant: DSTextVariant.titleLarge,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => Navigator.pushNamed(context, Routes.search),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final count = state is CartLoaded ? state.totalItems : 0;
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
                          onPressed: () =>
                              Navigator.pushNamed(context, Routes.cart),
                        ),
                        if (count > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: context.tokens.colorFeedbackError,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                count > 99 ? '99+' : '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ];
        },
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return switch (state) {
              HomeInitial() => const SizedBox.shrink(),
              HomeLoading() => const DSLoadingState(message: 'Cargando...'),
              HomeError(:final message) => DSErrorState(
                message: message,
                onRetry: () =>
                    context.read<HomeBloc>().add(const HomeLoadRequested()),
              ),
              HomeLoaded(:final categories, :final featuredProducts) =>
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const HomeRefreshRequested());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: DSSpacing.base),
                        CategoriesSection(categories: categories),
                        const SizedBox(height: DSSpacing.xl),
                        FeaturedProductsSection(products: featuredProducts),
                        const SizedBox(height: DSSpacing.xl),
                      ],
                    ),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
