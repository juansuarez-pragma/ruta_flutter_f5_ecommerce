import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/core/theme/app_theme.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';

/// Widget raíz de la aplicación.
///
/// Configura el tema, la navegación y los proveedores globales de BLoC.
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // CartBloc es global porque se necesita en múltiples pantallas
        BlocProvider(
          create: (_) => sl<CartBloc>()..add(const CartLoadRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Fake Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: Routes.home,
      ),
    );
  }
}
