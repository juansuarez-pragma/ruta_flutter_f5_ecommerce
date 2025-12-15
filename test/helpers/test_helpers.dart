import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

// ============================================================================
// WIDGET TEST HELPERS
// ============================================================================

/// Envuelve un widget con el tema del Design System para tests.
///
/// Todos los componentes del DS requieren FakeStoreTheme para funcionar.
///
/// ```dart
/// await tester.pumpWidget(buildTestableWidget(DSButton(...)));
/// ```
Widget buildTestableWidget(Widget child, {bool useScaffold = true}) {
  return MaterialApp(
    theme: FakeStoreTheme.light(),
    darkTheme: FakeStoreTheme.dark(),
    home: useScaffold ? Scaffold(body: child) : child,
  );
}

/// Envuelve para tests que requieren navegación completa.
Widget buildTestableApp({
  required Widget home,
  Map<String, WidgetBuilder>? routes,
}) {
  return MaterialApp(
    theme: FakeStoreTheme.light(),
    darkTheme: FakeStoreTheme.dark(),
    home: home,
    routes: routes ?? {},
  );
}

/// Helper para tests con Scaffold y AppBar.
Widget buildTestableScaffold({
  PreferredSizeWidget? appBar,
  required Widget body,
  Widget? bottomNavigationBar,
  Widget? floatingActionButton,
}) {
  return MaterialApp(
    theme: FakeStoreTheme.light(),
    home: Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    ),
  );
}

// ============================================================================
// EITHER MATCHERS - Para el Either custom del api_client
// ============================================================================

/// Matcher para verificar que un Either es Right (éxito).
///
/// ```dart
/// expect(result, isRight);
/// ```
const Matcher isRight = _IsRight();

class _IsRight extends Matcher {
  const _IsRight();

  @override
  bool matches(dynamic item, Map matchState) => item is Right;

  @override
  Description describe(Description description) =>
      description.add('is Right (success)');
}

/// Matcher para verificar que un Either es Left (error).
///
/// ```dart
/// expect(result, isLeft);
/// ```
const Matcher isLeft = _IsLeft();

class _IsLeft extends Matcher {
  const _IsLeft();

  @override
  bool matches(dynamic item, Map matchState) => item is Left;

  @override
  Description describe(Description description) =>
      description.add('is Left (failure)');
}

/// Matcher tipado para Right con valor específico.
///
/// ```dart
/// expect(result, isRightWith(expectedProducts));
/// ```
Matcher isRightWith<L, R>(R expectedValue) => _IsRightWith<L, R>(expectedValue);

class _IsRightWith<L, R> extends Matcher {
  const _IsRightWith(this.expectedValue);
  final R expectedValue;

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Right<L, R>) {
      return item.value == expectedValue;
    }
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('is Right with value $expectedValue');
}

/// Matcher tipado para Left con failure específico.
///
/// ```dart
/// expect(result, isLeftWithType<ConnectionFailure>());
/// ```
Matcher isLeftWithType<T>() => _IsLeftWithType<T>();

class _IsLeftWithType<T> extends Matcher {
  const _IsLeftWithType();

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Left) {
      return item.value is T;
    }
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('is Left with type $T');
}

// ============================================================================
// PUMP HELPERS
// ============================================================================

/// Extension para WidgetTester con helpers comunes.
extension WidgetTesterX on WidgetTester {
  /// Pump widget con tema del DS y espera a que se estabilice.
  Future<void> pumpTestableWidget(Widget widget, {Duration? duration}) async {
    await pumpWidget(buildTestableWidget(widget));
    if (duration != null) {
      await pump(duration);
    }
  }

  /// Pump y settle para animaciones.
  Future<void> pumpAndSettleTestable(Widget widget) async {
    await pumpWidget(buildTestableWidget(widget));
    await pumpAndSettle();
  }
}

// ============================================================================
// GOLDEN TEST HELPERS (para tests visuales futuros)
// ============================================================================

/// Configuración para golden tests del Design System.
Future<void> loadFontsForGoldenTests() async {
  // Cargar fuentes si es necesario para golden tests
  TestWidgetsFlutterBinding.ensureInitialized();
}
