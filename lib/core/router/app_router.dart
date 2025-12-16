import 'package:flutter/material.dart';

import 'package:ecommerce/features/home/home.dart';
import 'package:ecommerce/features/products/products.dart';
import 'package:ecommerce/features/categories/categories.dart';
import 'package:ecommerce/features/cart/cart.dart';
import 'package:ecommerce/features/checkout/checkout.dart';
import 'package:ecommerce/features/search/search.dart';
import 'package:ecommerce/features/orders/orders.dart';
import 'package:ecommerce/features/auth/auth.dart';
import 'package:ecommerce/features/support/support.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/core/router/auth_wrapper.dart';

/// Configuración del router de la aplicación.
///
/// Maneja la generación de rutas basada en rutas nombradas.
class AppRouter {
  AppRouter._();

  /// Genera la ruta correspondiente basada en la configuración.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.authWrapper:
        return MaterialPageRoute(
          builder: (_) => const AuthWrapper(),
          settings: settings,
        );

      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );

      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      case Routes.products:
        final args = settings.arguments as Map<String, dynamic>?;
        final category = args?['category'] as String?;
        return MaterialPageRoute(
          builder: (_) => ProductsPage(category: category),
          settings: settings,
        );

      case Routes.categories:
        return MaterialPageRoute(
          builder: (_) => const CategoriesPage(),
          settings: settings,
        );

      case Routes.cart:
        return MaterialPageRoute(
          builder: (_) => const CartPage(),
          settings: settings,
        );

      case Routes.checkout:
        return MaterialPageRoute(
          builder: (_) => const CheckoutPage(),
          settings: settings,
        );

      case Routes.orderConfirmation:
        return MaterialPageRoute(
          builder: (_) => const OrderConfirmationPage(),
          settings: settings,
        );

      case Routes.search:
        return MaterialPageRoute(
          builder: (_) => const SearchPage(),
          settings: settings,
        );

      case Routes.orderHistory:
        return MaterialPageRoute(
          builder: (_) => const OrderHistoryPage(),
          settings: settings,
        );

      case Routes.support:
        return MaterialPageRoute(
          builder: (_) => const SupportPage(),
          settings: settings,
        );

      case Routes.contact:
        return MaterialPageRoute(
          builder: (_) => const ContactPage(),
          settings: settings,
        );

      default:
        // Manejar rutas con parámetros como /product/:id
        if (settings.name?.startsWith('/product/') ?? false) {
          final idString = settings.name!.split('/').last;
          final id = int.tryParse(idString);
          if (id != null) {
            return MaterialPageRoute(
              builder: (_) => ProductDetailPage(productId: id),
              settings: settings,
            );
          }
        }
        return _notFoundRoute(settings);
    }
  }

  static Route<dynamic> _notFoundRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Página no encontrada')),
      ),
      settings: settings,
    );
  }
}
