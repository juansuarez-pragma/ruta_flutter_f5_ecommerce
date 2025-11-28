import 'package:flutter/material.dart';

import 'package:ecommerce/app.dart';
import 'package:ecommerce/core/di/injection_container.dart' as di;

/// Punto de entrada de la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias
  await di.initDependencies();

  runApp(const EcommerceApp());
}
