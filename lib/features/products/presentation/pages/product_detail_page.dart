import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/utils/extensions.dart';
import 'package:ecommerce/shared/widgets/quantity_selector.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_detail_bloc.dart';

/// Página de detalle de producto.
class ProductDetailPage extends StatefulWidget {
  /// ID del producto a mostrar.
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProductDetailBloc>()
            ..add(ProductDetailLoadRequested(widget.productId)),
      child: Scaffold(
        appBar: DSAppBar(
          title: 'Detalle',
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            return switch (state) {
              ProductDetailInitial() => const SizedBox.shrink(),
              ProductDetailLoading() => const DSLoadingState(
                message: 'Cargando producto...',
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
      ),
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del producto
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
                size: 64,
                color: tokens.colorTextTertiary,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(DSSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                DSText(product.title, variant: DSTextVariant.headingSmall),
                const SizedBox(height: DSSpacing.sm),

                // Rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 20,
                      color: tokens.colorFeedbackWarning,
                    ),
                    const SizedBox(width: DSSpacing.xs),
                    DSText(
                      '${product.rating.rate}',
                      variant: DSTextVariant.bodyMedium,
                    ),
                    DSText(
                      ' (${product.rating.count} reseñas)',
                      variant: DSTextVariant.bodySmall,
                      color: tokens.colorTextSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: DSSpacing.base),

                // Precio
                DSText(
                  product.price.toCurrency,
                  variant: DSTextVariant.headingMedium,
                  color: tokens.colorBrandPrimary,
                ),
                const SizedBox(height: DSSpacing.base),

                // Categoría
                DSBadge(
                  text: product.category.titleCase,
                  type: DSBadgeType.info,
                ),
                const SizedBox(height: DSSpacing.lg),

                // Descripción
                DSText('Descripción', variant: DSTextVariant.titleMedium),
                const SizedBox(height: DSSpacing.sm),
                DSText(
                  product.description,
                  variant: DSTextVariant.bodyMedium,
                  color: tokens.colorTextSecondary,
                ),
                const SizedBox(height: DSSpacing.xl),

                // Selector de cantidad
                Row(
                  children: [
                    DSText('Cantidad:', variant: DSTextVariant.titleSmall),
                    const SizedBox(width: DSSpacing.base),
                    QuantitySelector(
                      quantity: _quantity,
                      onChanged: (value) => setState(() => _quantity = value),
                    ),
                  ],
                ),
                const SizedBox(height: DSSpacing.lg),

                // Botón agregar al carrito
                DSButton.primary(
                  text: 'Agregar al carrito',
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
    context.showSnackBar('Producto agregado al carrito');
    setState(() => _quantity = 1);
  }
}
