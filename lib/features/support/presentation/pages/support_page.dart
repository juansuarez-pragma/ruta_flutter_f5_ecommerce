import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/features/support/support.dart';

/// Página principal de soporte con FAQs.
class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupportBloc>()..add(const SupportFAQsLoadRequested()),
      child: const _SupportPageContent(),
    );
  }
}

class _SupportPageContent extends StatelessWidget {
  const _SupportPageContent();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      appBar: DSAppBar(
        title: 'Soporte y Ayuda',
        actions: [
          DSIconButton(
            icon: Icons.contact_mail_outlined,
            onPressed: () => Navigator.pushNamed(context, Routes.contact),
            tooltip: 'Contactar soporte',
          ),
        ],
      ),
      body: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          if (state is SupportLoading) {
            return const Center(child: DSCircularLoader());
          }

          if (state is SupportError) {
            return DSErrorState(
              message: state.message,
              onRetry: () => context.read<SupportBloc>().add(
                    const SupportFAQsLoadRequested(),
                  ),
            );
          }

          if (state is SupportFAQsLoaded) {
            return Column(
              children: [
                // Category filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(DSSpacing.base),
                  child: Row(
                    children: [
                      _CategoryChip(
                        label: 'Todos',
                        isSelected: state.selectedCategory == null,
                        onTap: () => context.read<SupportBloc>().add(
                              const SupportFAQsLoadRequested(),
                            ),
                      ),
                      const SizedBox(width: DSSpacing.xs),
                      ..._buildCategoryChips(context, state.selectedCategory),
                    ],
                  ),
                ),

                // FAQs List
                Expanded(
                  child: state.faqs.isEmpty
                      ? DSEmptyState(
                          icon: Icons.help_outline,
                          title: 'No hay FAQs disponibles',
                          description: 'Intenta con otra categoría',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(DSSpacing.base),
                          itemCount: state.faqs.length,
                          itemBuilder: (context, index) {
                            return FAQCard(faqItem: state.faqs[index]);
                          },
                        ),
                ),
              ],
            );
          }

          return const DSEmptyState(
            icon: Icons.help_outline,
            title: 'Bienvenido a Soporte',
            description: 'Cargando preguntas frecuentes...',
          );
        },
      ),
    );
  }

  List<Widget> _buildCategoryChips(
    BuildContext context,
    FAQCategory? selectedCategory,
  ) {
    return FAQCategory.values.map((category) {
      return Padding(
        padding: const EdgeInsets.only(right: DSSpacing.xs),
        child: _CategoryChip(
          label: _getCategoryLabel(category),
          isSelected: selectedCategory == category,
          onTap: () => context.read<SupportBloc>().add(
                SupportFAQsLoadRequested(category: category),
              ),
        ),
      );
    }).toList();
  }

  String _getCategoryLabel(FAQCategory category) {
    switch (category) {
      case FAQCategory.orders:
        return 'Pedidos';
      case FAQCategory.payments:
        return 'Pagos';
      case FAQCategory.shipping:
        return 'Envíos';
      case FAQCategory.returns:
        return 'Devoluciones';
      case FAQCategory.account:
        return 'Cuenta';
      case FAQCategory.general:
        return 'General';
    }
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DSFilterChip(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
