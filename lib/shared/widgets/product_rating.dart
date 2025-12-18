import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

/// Product rating widget using Design System tokens.
///
/// Shows a star with the rating and optionally the number of reviews.
class DSProductRating extends StatelessWidget {
  const DSProductRating({
    super.key,
    required this.rating,
    this.reviewCount,
    this.showReviewCount = true,
  });

  /// Rating value (0-5).
  final double rating;

  /// Review count (optional).
  final int? reviewCount;

  /// Whether to show the review count.
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
            '($reviewCount reviews)',
            variant: DSTextVariant.bodySmall,
            color: tokens.colorTextSecondary,
          ),
        ],
      ],
    );
  }
}
