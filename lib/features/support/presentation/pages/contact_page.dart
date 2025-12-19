import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/features/support/support.dart';

/// Contact page for sending support messages.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ContactPageContent();
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
      appBar: const DSAppBar(title: 'Contact Support'),
      body: BlocConsumer<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is SupportMessageSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const DSText(
                  'Message sent! We will get back to you soon.',
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
                                  'Need help?',
                                  variant: DSTextVariant.headingSmall,
                                  color: tokens.colorTextPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DSSpacing.sm),
                          DSText(
                            "Fill out the form and we'll contact you as soon as possible.",
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
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Your full name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.base),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'tu@email.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.base),

                  // Subject field
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      hintText: 'Short description of the topic',
                      prefixIcon: Icon(Icons.subject_outlined),
                    ),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Subject is required';
                      }
                      if (value.trim().length < 5) {
                        return 'Subject must be at least 5 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.base),

                  // Message field
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Describe your question or issue...',
                      prefixIcon: Icon(Icons.message_outlined),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 6,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Message must be at least 10 characters';
                      }
                      if (value.trim().length > 1000) {
                        return 'Message cannot exceed 1000 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: DSSpacing.xl),

                  // Submit button
                  DSButton(
                    text: 'Send message',
                    onPressed: isLoading ? null : () => _submitForm(context),
                    isLoading: isLoading,
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
                            'Other ways to reach us',
                            variant: DSTextVariant.bodySmall,
                            color: tokens.colorTextTertiary,
                          ),
                          const SizedBox(height: DSSpacing.sm),
                          const _ContactInfoRow(
                            icon: Icons.email,
                            text: 'support@fakestore.com',
                          ),
                          const SizedBox(height: DSSpacing.xs),
                          const _ContactInfoRow(
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
