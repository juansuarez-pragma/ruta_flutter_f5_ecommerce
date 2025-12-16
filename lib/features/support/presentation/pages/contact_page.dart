import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/features/support/support.dart';

/// Página de contacto para enviar mensajes al soporte.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupportBloc>(),
      child: const _ContactPageContent(),
    );
  }
}

class _ContactPageContent extends StatefulWidget {
  const _ContactPageContent();

  @override
  State<_ContactPageContent> createState() => _ContactPageContentState();
}

class _ContactPageContentState extends State<_ContactPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SupportBloc>().add(
            SupportContactMessageSent(
              name: _nameController.text,
              email: _emailController.text,
              subject: _subjectController.text,
              message: _messageController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      appBar: DSAppBar(title: 'Contactar Soporte'),
      body: BlocConsumer<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is SupportMessageSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const DSText(
                  '¡Mensaje enviado! Te responderemos pronto.',
                  color: DSColors.white,
                ),
                backgroundColor: tokens.colorFeedbackSuccess,
              ),
            );
            Navigator.pop(context);
          } else if (state is SupportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: DSText(
                  state.message,
                  color: DSColors.white,
                ),
                backgroundColor: tokens.colorFeedbackError,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SupportLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(DSSpacing.base),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(DSSpacing.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: tokens.colorBrandPrimary,
                              ),
                              const SizedBox(width: DSSpacing.sm),
                              Expanded(
                                child: DSText(
                                  '¿Necesitas ayuda?',
                                  variant: DSTextVariant.headingSmall,
                                  color: tokens.colorTextPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DSSpacing.sm),
                          DSText(
                            'Completa el formulario y nos pondremos en contacto contigo lo antes posible.',
                            color: tokens.colorTextSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: DSSpacing.lg),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Tu nombre completo',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es requerido';
                      }
                      if (value.trim().length < 2) {
                        return 'El nombre debe tener al menos 2 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.base),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      hintText: 'tu@email.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El correo electrónico es requerido';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.base),

                  // Subject field
                  TextFormField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: 'Asunto',
                      hintText: 'Breve descripción del tema',
                      prefixIcon: const Icon(Icons.subject_outlined),
                    ),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El asunto es requerido';
                      }
                      if (value.trim().length < 5) {
                        return 'El asunto debe tener al menos 5 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.base),

                  // Message field
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Mensaje',
                      hintText: 'Describe tu consulta o problema...',
                      prefixIcon: const Icon(Icons.message_outlined),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 6,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El mensaje es requerido';
                      }
                      if (value.trim().length < 10) {
                        return 'El mensaje debe tener al menos 10 caracteres';
                      }
                      if (value.trim().length > 1000) {
                        return 'El mensaje no puede exceder 1000 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.xl),

                  // Submit button
                  DSButton(
                    text: 'Enviar Mensaje',
                    onPressed: isLoading ? null : () => _submitForm(context),
                    isLoading: isLoading,
                    variant: DSButtonVariant.primary,
                    size: DSButtonSize.large,
                  ),

                  const SizedBox(height: DSSpacing.base),

                  // Contact info
                  Card(
                    color: tokens.colorSurfaceSecondary,
                    child: Padding(
                      padding: const EdgeInsets.all(DSSpacing.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DSText(
                            'Otras formas de contacto',
                            variant: DSTextVariant.bodySmall,
                            color: tokens.colorTextTertiary,
                          ),
                          const SizedBox(height: DSSpacing.sm),
                          _ContactInfoRow(
                            icon: Icons.email,
                            text: 'soporte@fakestore.com',
                          ),
                          const SizedBox(height: DSSpacing.xs),
                          _ContactInfoRow(
                            icon: Icons.phone,
                            text: '+1 (555) 123-4567',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ContactInfoRow extends StatelessWidget {
  const _ContactInfoRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      children: [
        Icon(
          icon,
          size: DSSizes.iconSm,
          color: tokens.colorIconSecondary,
        ),
        const SizedBox(width: DSSpacing.sm),
        DSText(
          text,
          variant: DSTextVariant.bodySmall,
          color: tokens.colorTextSecondary,
        ),
      ],
    );
  }
}
