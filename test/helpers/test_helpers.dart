import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_design_system/fake_store_design_system.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

// ============================================================================
// WIDGET TEST HELPERS
// ============================================================================

/// Wraps a widget with the Design System theme for tests.
///
/// All DS components require FakeStoreTheme to work.
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

/// Wraps a test app that requires full navigation/routing.
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

/// Helper for tests that need a Scaffold and AppBar.
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
// EITHER MATCHERS - For the api_client Either type
// ============================================================================

/// Matcher to assert an Either is Right (success).
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

/// Matcher to assert an Either is Left (failure).
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

/// Typed matcher for Right with an expected value.
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

/// Typed matcher for Left with a specific failure type.
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

/// WidgetTester extension with common helpers.
extension WidgetTesterX on WidgetTester {
  /// Pumps a widget with DS theme and optionally waits.
  Future<void> pumpTestableWidget(Widget widget, {Duration? duration}) async {
    await pumpWidget(buildTestableWidget(widget));
    if (duration != null) {
      await pump(duration);
    }
  }

  /// Pumps and settles animations.
  Future<void> pumpAndSettleTestable(Widget widget) async {
    await pumpWidget(buildTestableWidget(widget));
    await pumpAndSettle();
  }
}

// ============================================================================
// GOLDEN TEST HELPERS (for future visual tests)
// ============================================================================

/// Golden test setup for the Design System.
Future<void> loadFontsForGoldenTests() async {
  // Load fonts if needed for golden tests.
  TestWidgetsFlutterBinding.ensureInitialized();
}
