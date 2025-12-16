import 'package:flutter/material.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Card para mostrar una pregunta frecuente.
class FAQCard extends StatefulWidget {
  const FAQCard({
    required this.faqItem,
    super.key,
  });

  final FAQItem faqItem;

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Card(
      margin: const EdgeInsets.only(bottom: DSSpacing.sm),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(DSBorderRadius.base),
        child: Padding(
          padding: const EdgeInsets.all(DSSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DSText(
                      widget.faqItem.question,
                      variant: DSTextVariant.bodyLarge,
                      color: tokens.colorTextPrimary,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: tokens.colorIconSecondary,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: DSSpacing.sm),
                DSText(
                  widget.faqItem.answer,
                  color: tokens.colorTextSecondary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
