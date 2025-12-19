import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/utils/extensions.dart';
import 'package:ecommerce/shared/widgets/widgets.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_detail_bloc.dart';

/// Product detail page.
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  /// Product id to display.
  final int productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSAppBar(
        title: 'Details',
        actions: [
          DSIconButton(
            icon: Icons.shopping_cart_outlined,
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          return switch (state) {
            ProductDetailInitial() => const SizedBox.shrink(),
            ProductDetailLoading() => const DSLoadingState(
              message: 'Loading product...',
            ),
            ProductDetailError(:final message) => DSErrorState(
              message: message,
              onRetry: () => context.read<ProductDetailBloc>().add(
                ProductDetailLoadRequested(widget.productId),
              ),
            ),
            ProductDetailLoaded(:final product) => _buildContent(
              context,
              product,
            ),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product image
          Container(
            height: 300,
            color: tokens.colorSurfaceSecondary,
            padding: const EdgeInsets.all(DSSpacing.xl),
            child: CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.contain,
              placeholder: (_, __) => const Center(child: DSCircularLoader()),
              errorWidget: (_, __, ___) => Icon(
                Icons.image_not_supported,
                size: DSSizes.iconMega,
                color: tokens.colorTextTertiary,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(DSSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                DSText(product.title, variant: DSTextVariant.headingSmall),
                const SizedBox(height: DSSpacing.sm),

                // Rating
                DSProductRating(
                  rating: product.rating.rate,
                  reviewCount: product.rating.count,
                ),
                const SizedBox(height: DSSpacing.base),

                // Price
                DSText(
                  product.price.toCurrency,
                  variant: DSTextVariant.headingMedium,
                  color: tokens.colorBrandPrimary,
                ),
                const SizedBox(height: DSSpacing.base),

                // Category
                DSBadge(
                  text: product.category.titleCase,
                  type: DSBadgeType.info,
                ),
                const SizedBox(height: DSSpacing.lg),

                // Description
                const DSText('Description', variant: DSTextVariant.titleMedium),
                const SizedBox(height: DSSpacing.sm),
                DSText(product.description, color: tokens.colorTextSecondary),
                const SizedBox(height: DSSpacing.xl),

                // Quantity selector
                Row(
                  children: [
                    const DSText(
                      'Quantity:',
                      variant: DSTextVariant.titleSmall,
                    ),
                    const SizedBox(width: DSSpacing.base),
                    QuantitySelector(
                      quantity: _quantity,
                      onChanged: (value) => setState(() => _quantity = value),
                    ),
                  ],
                ),
                const SizedBox(height: DSSpacing.lg),

                // Add to cart button
                DSButton.primary(
                  text: 'Add to cart',
                  icon: Icons.shopping_cart,
                  isFullWidth: true,
                  onPressed: () => _addToCart(context, product),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, Product product) {
    context.read<CartBloc>().add(
      CartItemAdded(product: product, quantity: _quantity),
    );
    context.showSnackBar('Product added to cart');
    setState(() => _quantity = 1);
  }
}
