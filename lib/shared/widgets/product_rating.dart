import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

/// Widget de rating de producto usando tokens del Design System.
///
/// Muestra una estrella con el rating y opcionalmente el número de reseñas.
class DSProductRating extends StatelessWidget {
  const DSProductRating({
    super.key,
    required this.rating,
    this.reviewCount,
    this.showReviewCount = true,
  });

  /// Valor del rating (0-5).
  final double rating;

  /// Número de reseñas (opcional).
  final int? reviewCount;

  /// Si debe mostrar el texto de reseñas.
  final bool showReviewCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: DSSizes.iconSm,
          color: tokens.colorFeedbackWarning,
        ),
        const SizedBox(width: DSSpacing.xs),
        DSText(rating.toStringAsFixed(1)),
        if (showReviewCount && reviewCount != null) ...[
          const SizedBox(width: DSSpacing.xs),
          DSText(
            '($reviewCount reseñas)',
            variant: DSTextVariant.bodySmall,
            color: tokens.colorTextSecondary,
          ),
        ],
      ],
    );
  }
}
