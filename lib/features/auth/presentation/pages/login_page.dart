import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';

/// Página de inicio de sesión.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, Routes.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: tokens.colorFeedbackError,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DSSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: DSSpacing.xxl),

                    // Logo
                    Icon(
                      Icons.storefront,
                      size: DSSizes.iconMega,
                      color: tokens.colorBrandPrimary,
                    ),
                    const SizedBox(height: DSSpacing.base),
                    DSText(
                      'Fake Store',
                      variant: DSTextVariant.headingMedium,
                      textAlign: TextAlign.center,
                      color: tokens.colorTextPrimary,
                    ),
                    const SizedBox(height: DSSpacing.xs),
                    DSText(
                      'Inicia sesión para continuar',
                      textAlign: TextAlign.center,
                      color: tokens.colorTextSecondary,
                    ),

                    const SizedBox(height: DSSpacing.xxl),

                    // Campo de email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'ejemplo@correo.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DSBorderRadius.base),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu correo electrónico';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DSSpacing.base),

                    // Campo de contraseña
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(DSBorderRadius.base),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu contraseña';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DSSpacing.xl),

                    // Botón de login
                    DSButton(
                      text: state is AuthLoading ? 'Iniciando sesión...' : 'Iniciar sesión',
                      onPressed: state is AuthLoading ? null : _onLoginPressed,
                      isLoading: state is AuthLoading,
                    ),

                    const SizedBox(height: DSSpacing.lg),

                    // Link a registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DSText(
                          '¿No tienes cuenta? ',
                          color: tokens.colorTextSecondary,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.register);
                          },
                          child: DSText(
                            'Regístrate',
                            color: tokens.colorBrandPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: DSSpacing.xl),

                    // Link para continuar sin cuenta
                    Center(
                      child: DSButton(
                        text: 'Continuar sin cuenta',
                        variant: DSButtonVariant.ghost,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.home);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
