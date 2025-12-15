import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/utils/extensions.dart';
import 'package:ecommerce/shared/widgets/quantity_selector.dart';
import 'package:ecommerce/features/cart/domain/entities/cart_item.dart';

/// Tile para mostrar un item del carrito.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  /// Item del carrito a mostrar.
  final CartItem item;

  /// Callback cuando cambia la cantidad.
  final ValueChanged<int> onQuantityChanged;

  /// Callback cuando se elimina el item.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DSCard(
      padding: const EdgeInsets.all(DSSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(DSBorderRadius.sm),
            child: CachedNetworkImage(
              imageUrl: item.product.image,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              placeholder: (_, __) => const DSSkeleton(width: 80, height: 80),
              errorWidget: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: tokens.colorSurfaceSecondary,
                child: Icon(
                  Icons.image_not_supported,
                  color: tokens.colorTextTertiary,
                ),
              ),
            ),
          ),
          const SizedBox(width: DSSpacing.sm),
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DSText(
                  item.product.title,
                  variant: DSTextVariant.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: DSSpacing.xs),
                DSText(
                  item.totalPrice.toCurrency,
                  variant: DSTextVariant.titleMedium,
                  color: tokens.colorBrandPrimary,
                ),
                const SizedBox(height: DSSpacing.xs),
                DSText(
                  '${item.product.price.toCurrency} c/u',
                  variant: DSTextVariant.bodySmall,
                  color: tokens.colorTextSecondary,
                ),
              ],
            ),
          ),
          // Controles de cantidad
          Column(
            children: [
              QuantitySelector(
                quantity: item.quantity,
                onChanged: onQuantityChanged,
              ),
              const SizedBox(height: DSSpacing.xs),
              DSIconButton(
                icon: Icons.delete_outline,
                onPressed: onRemove,
                size: DSButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
