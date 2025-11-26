import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection_container.dart' as di;

/// Punto de entrada de la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias
  await di.initDependencies();

  runApp(const EcommerceApp());
}
