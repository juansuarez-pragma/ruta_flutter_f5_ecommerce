import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/features/auth/auth.dart';
import 'package:ecommerce/features/home/presentation/pages/home_page.dart';

/// Wrapper que maneja la navegación basada en el estado de autenticación.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Usuario autenticado, ir a home
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home,
            (route) => false,
          );
        } else if (state is AuthUnauthenticated) {
          // Usuario no autenticado, ir a login
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.login,
            (route) => false,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Mostrar loading mientras verifica autenticación
          if (state is AuthLoading || state is AuthInitial) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Si está autenticado, mostrar home
          if (state is AuthAuthenticated) {
            return const HomePage();
          }

          // Si no está autenticado, el listener redirigirá a login
          // Mientras tanto, mostrar loading
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
