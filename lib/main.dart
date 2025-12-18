import 'package:flutter/material.dart';

import 'package:ecommerce/app.dart';
import 'package:ecommerce/core/di/injection_container.dart' as di;

/// Application entry point.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies.
  await di.initDependencies();

  runApp(const EcommerceApp());
}
