import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/shared/widgets/app_scaffold.dart';
import 'package:ecommerce/features/auth/auth.dart';

/// Página de perfil del usuario.
///
/// Muestra información del usuario autenticado y opciones de navegación.
/// Incluye funcionalidad de logout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      currentIndex: 3,
      body: _ProfilePageContent(),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  const _ProfilePageContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Redirigir a login después de logout
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.login,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: DSCircularLoader());
        }

        if (state is AuthAuthenticated) {
          return _AuthenticatedProfile(user: state.user);
        }

        // Usuario no autenticado
        return _UnauthenticatedProfile();
      },
    );
  }
}

/// Vista para usuario autenticado.
class _AuthenticatedProfile extends StatelessWidget {
  const _AuthenticatedProfile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header con información del usuario
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DSSpacing.xl),
            decoration: BoxDecoration(
              color: tokens.colorBrandPrimary,
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: tokens.colorBrandPrimaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: tokens.colorBrandPrimary,
                  ),
                ),
                const SizedBox(height: DSSpacing.base),

                // Nombre completo
                DSText(
                  user.fullName,
                  variant: DSTextVariant.headingMedium,
                  color: DSColors.white,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DSSpacing.xs),

                // Email
                DSText(
                  user.email,
                  variant: DSTextVariant.bodyMedium,
                  color: DSColors.white.withOpacity(0.87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DSSpacing.xs),

                // Username
                DSText(
                  '@${user.username}',
                  variant: DSTextVariant.bodySmall,
                  color: DSColors.white.withOpacity(0.60),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: DSSpacing.base),

          // Opciones de navegación
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.base),
            child: Column(
              children: [
                _ProfileOption(
                  icon: Icons.receipt_long_outlined,
                  title: 'Mis Pedidos',
                  subtitle: 'Ver historial de compras',
                  onTap: () => Navigator.pushNamed(context, Routes.orderHistory),
                ),
                const SizedBox(height: DSSpacing.xs),
                _ProfileOption(
                  icon: Icons.support_agent_outlined,
                  title: 'Soporte y Ayuda',
                  subtitle: 'FAQs y contacto',
                  onTap: () => Navigator.pushNamed(context, Routes.support),
                ),
                const SizedBox(height: DSSpacing.xs),
                _ProfileOption(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Mis Compras',
                  subtitle: 'Productos favoritos y guardados',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función próximamente'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: DSSpacing.xs),
                _ProfileOption(
                  icon: Icons.settings_outlined,
                  title: 'Configuración',
                  subtitle: 'Preferencias de la cuenta',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función próximamente'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: DSSpacing.xl),

                // Información adicional
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(DSSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DSText(
                          'Información de la cuenta',
                          variant: DSTextVariant.titleSmall,
                          color: tokens.colorTextPrimary,
                        ),
                        const SizedBox(height: DSSpacing.sm),
                        _InfoRow(
                          label: 'Usuario ID',
                          value: '#${user.id}',
                        ),
                        const SizedBox(height: DSSpacing.xs),
                        _InfoRow(
                          label: 'Estado',
                          value: user.isAuthenticated ? 'Activa' : 'Inactiva',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: DSSpacing.xl),

                // Botón de logout
                DSButton(
                  text: 'Cerrar Sesión',
                  onPressed: () => _showLogoutDialog(context),
                  variant: DSButtonVariant.secondary,
                  size: DSButtonSize.large,
                  icon: Icons.logout,
                ),

                const SizedBox(height: DSSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const DSText(
          '¿Cerrar sesión?',
          variant: DSTextVariant.headingSmall,
        ),
        content: const DSText(
          '¿Estás seguro de que deseas cerrar tu sesión?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: DSText(
              'Cancelar',
              color: context.tokens.colorTextSecondary,
            ),
          ),
          DSButton(
            text: 'Cerrar Sesión',
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            variant: DSButtonVariant.primary,
            size: DSButtonSize.small,
          ),
        ],
      ),
    );
  }
}

/// Vista para usuario no autenticado.
class _UnauthenticatedProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DSSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 100,
              color: tokens.colorIconSecondary,
            ),
            const SizedBox(height: DSSpacing.lg),
            DSText(
              'Inicia sesión',
              variant: DSTextVariant.headingLarge,
              color: tokens.colorTextPrimary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DSSpacing.sm),
            DSText(
              'Accede a tu perfil, historial de pedidos y más',
              color: tokens.colorTextSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DSSpacing.xl),
            DSButton(
              text: 'Iniciar Sesión',
              onPressed: () => Navigator.pushNamed(context, Routes.login),
              variant: DSButtonVariant.primary,
              size: DSButtonSize.large,
            ),
            const SizedBox(height: DSSpacing.base),
            DSButton(
              text: 'Crear Cuenta',
              onPressed: () => Navigator.pushNamed(context, Routes.register),
              variant: DSButtonVariant.secondary,
              size: DSButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para una opción de navegación.
class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DSBorderRadius.base),
        child: Padding(
          padding: const EdgeInsets.all(DSSpacing.base),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tokens.colorBrandPrimaryLight,
                  borderRadius: BorderRadius.circular(DSBorderRadius.sm),
                ),
                child: Icon(
                  icon,
                  color: tokens.colorBrandPrimary,
                ),
              ),
              const SizedBox(width: DSSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DSText(
                      title,
                      variant: DSTextVariant.titleSmall,
                      color: tokens.colorTextPrimary,
                    ),
                    const SizedBox(height: 2),
                    DSText(
                      subtitle,
                      variant: DSTextVariant.bodySmall,
                      color: tokens.colorTextSecondary,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: tokens.colorIconSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget para mostrar una fila de información.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DSText(
          label,
          color: tokens.colorTextSecondary,
        ),
        DSText(
          value,
          variant: DSTextVariant.titleSmall,
          color: tokens.colorTextPrimary,
        ),
      ],
    );
  }
}
