import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/router/app_router.dart';
import 'package:ecommerce/core/router/routes.dart';
import 'package:ecommerce/core/theme/app_theme.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/auth/auth.dart';

/// Root widget of the application.
///
/// Sets up theme, navigation, and global BLoC providers.
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // CartBloc is global because it is used across multiple screens.
        BlocProvider(
          create: (_) => sl<CartBloc>()..add(const CartLoadRequested()),
        ),
        // AuthBloc is global to manage authentication state.
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Fake Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: Routes.authWrapper,
      ),
    );
  }
}
