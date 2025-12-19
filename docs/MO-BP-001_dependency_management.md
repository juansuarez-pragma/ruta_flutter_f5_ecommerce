# MO-BP-001: Dependency Management

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | MO-BP-001 |
| **Type** | Best Practice |
| **Description** | Dependency Management |
| **Associated Quality Attribute** | Scalability |
| **Technology** | Mobile |
| **Responsible** | Mobile |
| **Capability** | Mobile |

---

## 1. Why (Business Justification)

### Business Rationale

> - Greater flexibility and adaptability to new requirements or technologies, extending useful life and avoiding costly implementations for the business.
> - Accelerates the implementation process, reducing time and costs.
> - Reduces maintenance, updates, and adaptation costs as the business evolves.

### Business Impact

| Metric | Poor Management | Good Management |
|--------|-----------------|-----------------|
| Security vulnerabilities | High risk | Minimal risk |
| Build time | Slow | Optimized |
| App size | Bloated | Lean |
| Upgrade effort | Days/weeks | Hours |

---

## 2. What (Technical Objective)

### Technical Goal

> Manage libraries and external components that the project requires to function correctly. Ensuring that appropriate dependency versions are available, avoiding conflicts and errors.

---

## 3. How (Implementation Strategy)

### Approaches

```
- Executing JS through webview
- Communicating with webview via postmessage
- Managing local packages within the repository
- Managing global packages outside the repository (unless monorepo architecture)
- Communicating with native via plugin (for APIs or SDK)
```

### 3.1 Version Pinning Strategies

```yaml
# pubspec.yaml

dependencies:
  # RECOMMENDED: Fixed versions for production stability
  flutter_bloc: 8.1.6
  get_it: 8.3.0
  dartz: 0.10.1

  # ACCEPTABLE: Caret for well-maintained packages only
  # Allows patch updates (8.1.6 -> 8.1.7)
  equatable: ^2.0.5

  # AVOID: Wide ranges create unpredictability
  # http: ">=0.13.0 <2.0.0"  # BAD: Too wide

  # NEVER: No version constraint
  # some_package:  # BAD: Any version

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
```

### 3.2 Local Package Management

```yaml
# For local packages within the repository
dependencies:
  design_system:
    path: ../packages/design_system
  api_client:
    path: ../packages/api_client

# Directory structure for monorepo
my_flutter_project/
├── apps/
│   └── main_app/
│       └── pubspec.yaml
├── packages/
│   ├── design_system/
│   │   ├── lib/
│   │   └── pubspec.yaml
│   ├── api_client/
│   │   ├── lib/
│   │   └── pubspec.yaml
│   └── shared_models/
│       ├── lib/
│       └── pubspec.yaml
└── melos.yaml  # For monorepo management
```

### 3.3 Git Dependencies

```yaml
# For packages from Git repositories
dependencies:
  # Specific commit (most stable)
  custom_package:
    git:
      url: https://github.com/company/custom_package.git
      ref: abc123def456  # Commit hash

  # Specific tag (for releases)
  another_package:
    git:
      url: https://github.com/company/another_package.git
      ref: v1.2.3

  # Subdirectory in monorepo
  shared_utils:
    git:
      url: https://github.com/company/flutter-packages.git
      path: packages/shared_utils
      ref: main
```

### 3.4 Dependency Analysis

```bash
# View dependency tree
flutter pub deps

# Check for outdated packages
flutter pub outdated

# Check for security vulnerabilities (using Trivy)
trivy fs --scanners vuln .

# Upgrade dependencies
flutter pub upgrade

# Get specific package info
flutter pub deps --style=compact | grep package_name
```

### 3.5 Native Plugin Communication

```dart
// lib/core/platform/native_bridge.dart

// For communicating with native code via MethodChannel
class NativeBridge {
  static const MethodChannel _channel = MethodChannel('com.company.app/native');

  static Future<String> getNativeData() async {
    try {
      final result = await _channel.invokeMethod<String>('getData');
      return result ?? '';
    } on PlatformException catch (e) {
      throw NativeBridgeException('Failed to get native data: ${e.message}');
    }
  }

  static Future<void> sendToNative(Map<String, dynamic> data) async {
    try {
      await _channel.invokeMethod('sendData', data);
    } on PlatformException catch (e) {
      throw NativeBridgeException('Failed to send data: ${e.message}');
    }
  }
}

// For EventChannel (streams from native)
class NativeEventBridge {
  static const EventChannel _eventChannel =
      EventChannel('com.company.app/events');

  static Stream<dynamic> get events => _eventChannel.receiveBroadcastStream();
}
```

### 3.6 WebView Communication

```dart
// For apps using WebView with JS communication
import 'package:webview_flutter/webview_flutter.dart';

class WebViewBridge {
  late final WebViewController controller;

  Future<void> initialize() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: _handleMessage,
      )
      ..loadRequest(Uri.parse('https://webapp.example.com'));
  }

  void _handleMessage(JavaScriptMessage message) {
    final data = jsonDecode(message.message);
    // Handle message from web
    switch (data['type']) {
      case 'navigation':
        _handleNavigation(data['payload']);
        break;
      case 'data':
        _handleData(data['payload']);
        break;
    }
  }

  Future<void> sendToWeb(Map<String, dynamic> data) async {
    final jsonData = jsonEncode(data);
    await controller.runJavaScript(
      'window.receiveFromFlutter($jsonData)',
    );
  }
}
```

### 3.7 Dependency Security Scanning

```yaml
# .github/workflows/security.yml
name: Security Scan

on:
  push:
    branches: [main]
  pull_request:
  schedule:
    - cron: '0 0 * * *'  # Daily scan

jobs:
  dependency-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'

      - name: Upload scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'

      - name: Check for pub.dev advisories
        run: |
          flutter pub outdated
          flutter pub deps --style=compact
```

### 3.8 Dependency Update Strategy

```dart
// lib/core/config/dependency_policy.dart

/// Dependency Update Policy
///
/// 1. PATCH updates (x.x.PATCH): Apply immediately
///    - Bug fixes, security patches
///    - Run tests, deploy if passing
///
/// 2. MINOR updates (x.MINOR.x): Apply within sprint
///    - New features, deprecations
///    - Review changelog, run full test suite
///
/// 3. MAJOR updates (MAJOR.x.x): Plan and schedule
///    - Breaking changes
///    - Create branch, update, test thoroughly
///    - Document migration steps
///
/// Review Schedule:
/// - Weekly: Check for security advisories
/// - Sprint start: Review flutter pub outdated
/// - Quarterly: Audit all dependencies for necessity
```

### 3.9 Lock File Management

```bash
# pubspec.lock should be committed for apps
# Ensures reproducible builds across team

# When to regenerate:
flutter pub upgrade  # Upgrades all packages to latest allowed
flutter pub get      # Gets versions from lock file

# For libraries (packages), pubspec.lock should NOT be committed
# Let consumers determine versions
```

### 3.10 Removing Unused Dependencies

```bash
# Identify unused dependencies
# Manual review of import statements

# Check what's using a dependency
grep -r "import.*package_name" lib/

# Before removing, ensure:
# 1. No imports in lib/
# 2. No imports in test/
# 3. Not a transitive dependency
# 4. Not used via reflection/code generation

# Regular audit
flutter pub deps --style=compact
```

---

## 4. Verification Checklist

- [ ] All production dependencies have fixed versions
- [ ] pubspec.lock committed to repository
- [ ] No unused dependencies in pubspec.yaml
- [ ] Security scanning in CI/CD pipeline
- [ ] Local packages properly organized
- [ ] Git dependencies use specific refs (not branches)
- [ ] Native communication abstracted through interfaces
- [ ] WebView security guidelines followed (if applicable)
- [ ] Dependency update policy documented
- [ ] Quarterly dependency audit scheduled

---

## 5. Interview Questions

### Question: How do you manage dependency versions?
**Answer:**
```
I follow a strict versioning strategy:

1. Fixed versions for production: flutter_bloc: 8.1.6
   - Reproducible builds
   - No surprise updates

2. Caret (^) only for very stable packages: equatable: ^2.0.5
   - Allows patch updates
   - Only for packages with excellent backwards compatibility

3. Lock file committed: pubspec.lock ensures team uses same versions

4. Regular updates:
   - Weekly security check
   - Sprint-start outdated review
   - Planned major updates

5. Security scanning: Trivy in CI catches vulnerabilities

For libraries I publish, I use wider ranges to allow flexibility
for consumers.
```

### Question: How do you handle native plugin dependencies?
**Answer:**
```
Native plugin management requires several considerations:

1. Plugin selection:
   - Check pub.dev scores (popularity, health, maintenance)
   - Review GitHub issues for compatibility problems
   - Verify platform support (Android, iOS, web)

2. Version pinning:
   - Use exact versions for native plugins
   - Native code is more sensitive to version changes

3. Fallback strategy:
   - Wrap plugin calls in try-catch
   - Have fallback for when plugin isn't available
   - Graceful degradation on unsupported platforms

4. Platform channels:
   - Abstract native communication behind interfaces
   - Makes testing easier with mock implementations
   - Centralizes platform-specific error handling

5. Testing:
   - Test on multiple Android/iOS versions
   - Check minimum SDK requirements match your targets
```

### Question: How do you audit dependencies?
**Answer:**
```
My dependency audit process:

1. Security scan:
   - Trivy scans in CI
   - Check pub.dev advisories
   - Monitor CVE databases

2. Necessity review:
   - Is each dependency still used?
   - Can we use a lighter alternative?
   - Is the functionality worth the size?

3. Health check:
   - Is package actively maintained?
   - Recent commits/releases?
   - Open issues handled?

4. Size impact:
   - flutter build --analyze-size
   - Which packages contribute most?
   - Are there smaller alternatives?

5. License compliance:
   - flutter pub deps --executables
   - Check for incompatible licenses
   - Document license obligations

Tools:
- flutter pub outdated
- flutter pub deps
- trivy fs .
- pub.dev dashboard
```

---

## 6. Additional Resources

- [Dart Package Management](https://dart.dev/tools/pub/dependencies)
- [Flutter Plugin Development](https://docs.flutter.dev/packages-and-plugins/developing-packages)
- [Trivy Scanner](https://github.com/aquasecurity/trivy)
- [Melos (Monorepo)](https://melos.invertase.dev/)

### Security References
- Pipeline Trivy: https://github.com/somospragma/devsecops-ci-pipe-yml-security
- MCP Trivy: Tool -> scan_filesystem

---

**Last update:** December 2024
**Version:** 1.0.0
