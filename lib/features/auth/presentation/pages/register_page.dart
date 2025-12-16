import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';

/// Página de registro de usuario.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthRegisterRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      ));
    }
  }

  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DSBorderRadius.base),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      appBar: DSAppBar(
        title: 'Crear cuenta',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                    DSText(
                      'Completa tus datos',
                      variant: DSTextVariant.headingMedium,
                      color: tokens.colorTextPrimary,
                    ),
                    const SizedBox(height: DSSpacing.xs),
                    DSText(
                      'Crea tu cuenta para acceder a todas las funciones',
                      color: tokens.colorTextSecondary,
                    ),

                    const SizedBox(height: DSSpacing.xl),

                    // Nombre y Apellido en fila
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: _buildInputDecoration(
                              label: 'Nombre',
                              hint: 'Juan',
                              prefixIcon: Icons.person_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: DSSpacing.base),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: _buildInputDecoration(
                              label: 'Apellido',
                              hint: 'Pérez',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: DSSpacing.base),

                    // Username
                    TextFormField(
                      controller: _usernameController,
                      decoration: _buildInputDecoration(
                        label: 'Nombre de usuario',
                        hint: 'juanperez',
                        prefixIcon: Icons.alternate_email,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un nombre de usuario';
                        }
                        if (value.length < 3) {
                          return 'Mínimo 3 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DSSpacing.base),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        label: 'Correo electrónico',
                        hint: 'ejemplo@correo.com',
                        prefixIcon: Icons.email_outlined,
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

                    // Contraseña
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _buildInputDecoration(
                        label: 'Contraseña',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outlined,
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa una contraseña';
                        }
                        if (value.length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DSSpacing.base),

                    // Confirmar contraseña
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: _buildInputDecoration(
                        label: 'Confirmar contraseña',
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outlined,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma tu contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: DSSpacing.xl),

                    // Botón de registro
                    DSButton(
                      text: state is AuthLoading ? 'Creando cuenta...' : 'Crear cuenta',
                      onPressed: state is AuthLoading ? null : _onRegisterPressed,
                      isLoading: state is AuthLoading,
                    ),

                    const SizedBox(height: DSSpacing.lg),

                    // Link a login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DSText(
                          '¿Ya tienes cuenta? ',
                          color: tokens.colorTextSecondary,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: DSText(
                            'Inicia sesión',
                            color: tokens.colorBrandPrimary,
                          ),
                        ),
                      ],
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
