# MOFE-MIN-002: Minification and Obfuscation

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | MOFE-MIN-002 |
| **Type** | Minimum (Mandatory) |
| **Description** | Minification and Obfuscation |
| **Associated Quality Attribute** | Security |
| **Technology** | Flutter, Android, iOS |
| **Responsible** | FrontEnd, Mobile |
| **Capability** | Mobile/Frontend |

---

## 1. Why (Business Justification)

### Business Rationale

> Makes it difficult for third parties to intercept, understand, and make modifications or alterations to the system, thus protecting intellectual property.

### Business Impact

#### Security Impact
- **Reverse engineering protection**: Obfuscated code is 10x harder to decompile
- **IP protection**: Business logic and algorithms are hidden
- **API security**: Endpoint URLs and keys are harder to extract
- **Competitive advantage**: Proprietary algorithms remain secret

#### Size Optimization Impact
| Metric | Before Optimization | After Optimization |
|--------|--------------------|--------------------|
| APK size | 50-80 MB | 15-25 MB |
| Download time (3G) | 2-4 minutes | 30-60 seconds |
| Install success rate | 85% | 95% |
| Storage complaints | High | Low |

#### Industry Context
- **60% of mobile apps** are vulnerable to reverse engineering
- **$12 billion** lost annually to app piracy
- App stores penalize large apps in search rankings
- Users are **2x more likely** to download smaller apps

---

## 2. What (Technical Objective)

### Technical Goal

> Reduce file sizes and hide original code, improving load speed (web)/download compiled (mobile) and making comprehension or modification by third parties difficult, optimizing performance and protecting intellectual property. Apply secure coding practices that favor attack prevention.

### Security Principles

1. **Defense in depth**: Multiple layers of protection
2. **Least privilege**: Request only necessary permissions
3. **Secure by default**: Production builds are always secured
4. **Input validation**: Never trust external data
5. **Secure storage**: Sensitive data properly encrypted

---

## 3. How (Implementation Strategy)

### Implementation Approach

```
- Validate and sanitize all user input and external data
- Protect credentials and sensitive data; never expose them in code or insecure storage
- Use secure mechanisms for credential storage
- Use secure encryption for data that requires it, both at rest and in transit
- Use secure communication (HTTPS/TLS) on all connections
- Implement access and authorization controls in backend
- Keep dependencies and libraries updated and free of known vulnerabilities
- Prevent common vulnerabilities (XSS, CSRF, code injection, clickjacking)
- Handle errors and exceptions without exposing internal or sensitive information
- Do not log or display sensitive data in logs, error messages, or public interfaces
- Build environment variables should be stored properly as secrets in CI/CD or
  specialized secret management services
```

---

## 4. Way to do it (Flutter Instructions)

### 4.1 Build Commands for Production

```bash
# Android - Release build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Android - App Bundle (recommended for Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# iOS - Release build with obfuscation
flutter build ios --release --obfuscate --split-debug-info=build/debug-info

# iOS - IPA for distribution
flutter build ipa --release --obfuscate --split-debug-info=build/debug-info

# Web - Production build (minified by default)
flutter build web --release --web-renderer canvaskit

# IMPORTANT: Store split-debug-info for crash report symbolication
# Upload to Firebase Crashlytics or Sentry
```

### 4.2 Android ProGuard/R8 Configuration

```groovy
// android/app/build.gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'

            // Sign with release key
            signingConfig signingConfigs.release
        }
    }
}
```

```proguard
# android/app/proguard-rules.pro

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Firebase (if used)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Gson (if used for JSON)
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

# Retrofit (if used)
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# Project-specific exclusions
# Add classes that use reflection or dynamic invocation
# -keep class com.yourpackage.models.** { *; }
```

### 4.3 iOS Build Settings

```ruby
# ios/Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'

      # Strip debug symbols in release
      if config.name == 'Release'
        config.build_settings['STRIP_INSTALLED_PRODUCT'] = 'YES'
        config.build_settings['STRIP_STYLE'] = 'all'
        config.build_settings['DEPLOYMENT_POSTPROCESSING'] = 'YES'
      end
    end
  end
end
```

### 4.4 Mapping Files Management

```bash
# Generate mapping files during build
flutter build apk --release --obfuscate --split-debug-info=build/debug-info/android
flutter build ios --release --obfuscate --split-debug-info=build/debug-info/ios

# Store mapping files securely
# Directory structure:
# build/
# └── debug-info/
#     ├── android/
#     │   ├── app.android-arm64.symbols
#     │   └── app.android-arm.symbols
#     └── ios/
#         └── app.ios-arm64.symbols

# Upload to Firebase Crashlytics
firebase crashlytics:symbols:upload --app=YOUR_APP_ID build/debug-info/android

# For Sentry
sentry-cli upload-dif --org YOUR_ORG --project YOUR_PROJECT build/debug-info/
```

### 4.5 CI/CD Secret Management

```yaml
# .github/workflows/build.yml
name: Build Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.2'

      - name: Decode Keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/keystore.jks

      - name: Create key.properties
        run: |
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties

      - name: Build APK
        run: |
          flutter build apk --release \
            --obfuscate \
            --split-debug-info=build/debug-info \
            --dart-define=API_URL=${{ secrets.API_URL }} \
            --dart-define=API_KEY=${{ secrets.API_KEY }}

      - name: Upload Debug Symbols
        run: |
          firebase crashlytics:symbols:upload \
            --app=${{ secrets.FIREBASE_APP_ID }} \
            build/debug-info

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

### 4.6 Secure Storage for Credentials

```dart
// INCORRECT: Hardcoded credentials
const apiKey = 'sk_live_abc123'; // BAD: In source code!

// INCORRECT: Plain SharedPreferences
await prefs.setString('auth_token', token); // BAD: Not encrypted!

// CORRECT: Use flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

// CORRECT: Use environment variables for build-time secrets
// Build command:
// flutter build apk --dart-define=API_KEY=your_key

class ApiConfig {
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '', // Empty in source, set at build time
  );
}
```

### 4.7 Permission Management

```dart
// Request only necessary permissions
// android/app/src/main/AndroidManifest.xml
<manifest>
    <!-- Only request what you actually use -->
    <uses-permission android:name="android.permission.INTERNET"/>

    <!-- DON'T request unless needed -->
    <!-- <uses-permission android:name="android.permission.CAMERA"/> -->
    <!-- <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/> -->
</manifest>

// Runtime permission request with justification
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission(BuildContext context) async {
  final status = await Permission.camera.status;

  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    // Show rationale before requesting
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission'),
        content: const Text(
          'We need camera access to scan product barcodes. '
          'Your camera data is never stored or transmitted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    if (shouldRequest == true) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
  }

  return false;
}
```

### 4.8 Disable Debug Logging in Production

```dart
// lib/core/utils/logger.dart
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, {String? name, Object? error}) {
    // Only log in debug mode
    if (kDebugMode) {
      developer.log(
        message,
        name: name ?? 'App',
        error: error,
      );
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      developer.log(message, name: 'INFO', level: 800);
    }
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'ERROR',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }

    // Always report to crash monitoring (sanitized)
    _reportToMonitoring(message, error, stackTrace);
  }

  static void _reportToMonitoring(
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    // Sanitize before sending
    final sanitizedMessage = _sanitize(message);
    // Send to Crashlytics/Sentry
  }

  static String _sanitize(String input) {
    // Remove potential sensitive data
    return input
        .replaceAll(RegExp(r'Bearer [A-Za-z0-9-_]+'), 'Bearer [REDACTED]')
        .replaceAll(RegExp(r'"password":\s*"[^"]*"'), '"password": "[REDACTED]"')
        .replaceAll(RegExp(r'\b\d{16}\b'), '[CARD_REDACTED]');
  }
}

// Usage
AppLogger.log('User logged in'); // Only in debug
AppLogger.error('Payment failed', error: e); // Logged + reported
```

### 4.9 Build Size Verification

```bash
#!/bin/bash
# scripts/verify_build_size.sh

# Build release APK
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Get APK size
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
APK_SIZE=$(stat -f%z "$APK_PATH" 2>/dev/null || stat -c%s "$APK_PATH")
APK_SIZE_MB=$((APK_SIZE / 1048576))

echo "APK Size: ${APK_SIZE_MB}MB"

# Verify size is under threshold
MAX_SIZE_MB=30
if [ "$APK_SIZE_MB" -gt "$MAX_SIZE_MB" ]; then
  echo "ERROR: APK size (${APK_SIZE_MB}MB) exceeds limit (${MAX_SIZE_MB}MB)"
  exit 1
fi

# Compare with previous build
if [ -f "build/.previous_size" ]; then
  PREV_SIZE=$(cat build/.previous_size)
  DIFF=$((APK_SIZE - PREV_SIZE))
  DIFF_MB=$((DIFF / 1048576))
  echo "Size change: ${DIFF_MB}MB from previous build"

  # Alert if significant increase
  if [ "$DIFF" -gt 2097152 ]; then  # 2MB
    echo "WARNING: Significant size increase detected"
  fi
fi

echo "$APK_SIZE" > build/.previous_size
echo "Build verification passed"
```

### 4.10 Obfuscation Verification

```dart
// scripts/verify_obfuscation.dart
// Run after building to verify obfuscation worked

import 'dart:io';

void main() async {
  // Decompile APK (requires apktool)
  final result = await Process.run('apktool', [
    'd',
    'build/app/outputs/flutter-apk/app-release.apk',
    '-o',
    'build/decompiled',
    '-f',
  ]);

  if (result.exitCode != 0) {
    print('Failed to decompile APK');
    exit(1);
  }

  // Check for sensitive strings that shouldn't be visible
  final sensitivePatterns = [
    'apiKey',
    'secretKey',
    'password',
    'Bearer',
    'https://api.', // Full API URLs
  ];

  final smaliDir = Directory('build/decompiled/smali');
  var foundSensitive = false;

  await for (final entity in smaliDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.smali')) {
      final content = await entity.readAsString();
      for (final pattern in sensitivePatterns) {
        if (content.contains(pattern)) {
          print('WARNING: Found "$pattern" in ${entity.path}');
          foundSensitive = true;
        }
      }
    }
  }

  if (foundSensitive) {
    print('Obfuscation verification FAILED');
    exit(1);
  }

  print('Obfuscation verification PASSED');

  // Cleanup
  await Directory('build/decompiled').delete(recursive: true);
}
```

### 4.11 Exclusion List Documentation

```dart
// lib/core/config/obfuscation_exclusions.dart

/// Classes excluded from obfuscation.
///
/// Add classes here that:
/// 1. Use reflection or dynamic invocation
/// 2. Are called from native code (C/C++)
/// 3. Are from third-party libraries that require it
/// 4. Implement Serializable/Parcelable with specific naming
///
/// Document the reason for each exclusion.
abstract class ObfuscationExclusions {
  /// Firebase models require original names for Firestore mapping
  /// Excluded in proguard-rules.pro:
  /// -keep class com.example.models.firebase.** { *; }
  static const firebaseModels = 'com.example.models.firebase';

  /// Payment SDK callbacks require original method names
  /// Excluded in proguard-rules.pro:
  /// -keep class com.example.payment.PaymentCallback { *; }
  static const paymentCallbacks = 'com.example.payment.PaymentCallback';

  /// JSON models using reflection-based serialization
  /// Consider migrating to code generation (json_serializable)
  /// Excluded in proguard-rules.pro:
  /// -keep class com.example.models.api.** { *; }
  static const apiModels = 'com.example.models.api';
}
```

---

## 5. Verification Checklist

### Build Configuration
- [ ] `--obfuscate` flag used in release builds
- [ ] `--split-debug-info` flag used (mapping files generated)
- [ ] Debug symbols stored securely for crash symbolication
- [ ] ProGuard/R8 enabled for Android
- [ ] iOS strip settings configured

### Secret Management
- [ ] No hardcoded credentials in source code
- [ ] Environment variables used for build-time secrets
- [ ] Secrets stored in CI/CD secret manager
- [ ] flutter_secure_storage used for runtime secrets
- [ ] key.properties excluded from version control

### Permission Management
- [ ] Only necessary permissions requested
- [ ] Runtime permission requests include rationale
- [ ] Permissions justified in app store listings

### Logging
- [ ] Debug logs disabled in production
- [ ] Sensitive data never logged
- [ ] Crash reports sanitized before sending

### Verification
- [ ] Build size compared before/after optimization
- [ ] Decompilation test performed
- [ ] Mapping files uploaded to crash monitoring
- [ ] Exclusion list documented

---

## 6. Importance of Defining at Project Start

### Why It Cannot Wait

1. **Security mindset**: Secure coding practices must be habits from day one, not afterthoughts.

2. **Build pipeline**: Setting up signing, obfuscation, and secrets management is easier before complexity grows.

3. **Dependency selection**: Some libraries don't work with obfuscation; better to know early.

4. **Size budgeting**: Establishing size limits early prevents creep.

5. **Compliance**: Many industries require obfuscation; retrofitting is expensive.

### Consequences of Not Doing It

| Problem | Consequence |
|---------|-------------|
| No obfuscation | Business logic easily reverse-engineered |
| Hardcoded secrets | Credentials extracted from APK |
| No mapping files | Crash reports unreadable |
| Large app size | Lower install rates, poor rankings |
| Debug logs in prod | Sensitive data exposed |

---

## 7. Technical Interview Questions - Senior Flutter

### Question 1: Obfuscation Purpose
**Interviewer:** "Why is obfuscation important for mobile apps?"

**Expected Answer:**
```
Obfuscation serves multiple critical purposes:

1. **Intellectual Property Protection**: Business logic, algorithms, and
   proprietary code become difficult to understand when decompiled.

2. **Security Enhancement**: Attackers can't easily find vulnerabilities
   by reading clear code. API endpoints, validation logic, and security
   measures are hidden.

3. **API Key Protection**: While obfuscation isn't foolproof, it makes
   extracting hardcoded values significantly harder.

4. **Competitive Advantage**: Competitors can't easily copy implementation
   details or unique features.

5. **Compliance**: Some industries (finance, healthcare) require code
   protection as part of security standards.

Important caveat: Obfuscation is NOT encryption. A determined attacker
with enough time can still reverse engineer. It's one layer in a defense-
in-depth strategy, not the only protection.

Best practices:
- Never rely solely on obfuscation for security
- Keep truly sensitive logic on the server
- Use certificate pinning for API communication
- Implement runtime integrity checks
```

### Question 2: Mapping Files
**Interviewer:** "What are split-debug-info files and why are they important?"

**Expected Answer:**
```
Split-debug-info files (also called symbol files or mapping files) are
generated during obfuscated builds. They contain the mapping between
obfuscated names and original names.

Why they're critical:

1. **Crash Symbolication**: When an obfuscated app crashes, the stack
   trace shows meaningless names like 'a.b.c()'. Mapping files translate
   these back to 'UserService.login()'.

2. **Debugging Production Issues**: Without mapping files, production
   crashes are nearly impossible to diagnose.

3. **Historical Records**: Each build produces unique obfuscation. You
   need the exact mapping file for that specific build version.

Best practices:
- Generate with every release build:
  flutter build apk --obfuscate --split-debug-info=build/debug-info

- Store securely with build versioning
- Upload to crash monitoring (Crashlytics, Sentry)
- Never include in the distributed app
- Retain for the lifetime of that app version in production

Example workflow:
1. Build generates symbols in build/debug-info/
2. CI uploads symbols to Crashlytics
3. Crash occurs in production
4. Crashlytics uses symbols to show readable stack trace
5. Developer can identify exact line that crashed
```

### Question 3: Secure Storage
**Interviewer:** "How do you securely store sensitive data in Flutter?"

**Expected Answer:**
```
For secure storage in Flutter, I use a layered approach:

1. **Runtime Secrets (tokens, credentials)**:
   Use flutter_secure_storage which encrypts using:
   - Android: EncryptedSharedPreferences (AES-256)
   - iOS: Keychain Services

   final storage = FlutterSecureStorage();
   await storage.write(key: 'token', value: jwt);

2. **Build-time Secrets (API keys)**:
   Use dart-define during build, never in source code:
   flutter build apk --dart-define=API_KEY=$SECRET

   Access via:
   const apiKey = String.fromEnvironment('API_KEY');

3. **Truly Sensitive Data (payment, health)**:
   Don't store locally at all. Keep on secure backend.
   Use short-lived tokens for access.

Security considerations:
- Enable encrypted shared preferences on Android
- Use proper keychain accessibility on iOS
- Clear sensitive data on logout
- Implement biometric protection where appropriate
- Never log sensitive values

What NOT to use:
- SharedPreferences (not encrypted)
- File storage (accessible on rooted devices)
- SQLite without encryption
- Hardcoded values in source
```

### Question 4: Build Size Optimization
**Interviewer:** "How do you reduce Flutter app size?"

**Expected Answer:**
```
App size optimization involves multiple strategies:

1. **Build Configuration**:
   - Use app bundles (AAB) for Play Store (splits by device)
   - Enable R8/ProGuard for Android
   - Split APKs by ABI: --split-per-abi

2. **Asset Optimization**:
   - Compress images (WebP instead of PNG)
   - Use SVG for icons
   - Remove unused assets
   - Consider CDN for large assets

3. **Code Optimization**:
   - Remove unused packages from pubspec.yaml
   - Use tree shaking (enabled by default in release)
   - Avoid large dependencies for small features
   - Use deferred loading for rarely-used features

4. **Dependency Audit**:
   - flutter pub deps to see dependency tree
   - Look for transitive dependencies adding bloat
   - Consider lighter alternatives

5. **Font Optimization**:
   - Only include needed font weights
   - Use system fonts where appropriate
   - Subset custom fonts to used characters

Measurement:
- flutter build apk --analyze-size
- Compare builds before/after changes
- Set size budgets in CI (fail if exceeded)

Target sizes:
- Base Flutter app: ~15-20MB
- Reasonable app with features: 25-40MB
- Concern threshold: > 50MB
```

### Question 5: ProGuard Configuration
**Interviewer:** "How do you configure ProGuard for a Flutter app?"

**Expected Answer:**
```
ProGuard (now R8) configuration for Flutter requires careful handling:

1. **Enable in build.gradle**:
   buildTypes {
     release {
       minifyEnabled true
       shrinkResources true
       proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'),
                     'proguard-rules.pro'
     }
   }

2. **Flutter-specific rules** (always include):
   -keep class io.flutter.** { *; }
   -keep class io.flutter.plugins.** { *; }

3. **Plugin rules**: Many plugins need specific rules. Check plugin
   documentation. Common ones:
   - Firebase: Keep Firebase classes
   - Retrofit: Keep method signatures
   - Gson: Keep serialization attributes

4. **Reflection exclusions**: Classes using reflection need keeping:
   -keep class com.myapp.models.** { *; }

5. **Testing**: After enabling ProGuard:
   - Test all features thoroughly
   - Check native integrations
   - Verify JSON parsing
   - Test payment flows
   - Verify analytics

Common issues and fixes:
- App crashes: Add keep rule for crashed class
- JSON parsing fails: Keep model classes
- Native plugin breaks: Check plugin's proguard rules
- Reflection fails: Keep classes using reflection

Debugging:
-printusage build/outputs/proguard/usage.txt
-printmapping build/outputs/proguard/mapping.txt
```

### Question 6: Real Challenge Solved
**Interviewer:** "Tell me about a security or optimization challenge you've solved"

**Expected Answer:**
```
In a banking app, we discovered sensitive data exposure:

Problem identified:
- Security audit found API keys visible in decompiled APK
- Auth tokens stored in plain SharedPreferences
- Full API URLs exposed in strings
- Debug logs contained user data
- App size was 80MB (user complaints)

Investigation:
1. Decompiled release APK with apktool
2. Found hardcoded API keys in Dart code
3. SharedPreferences contained plain tokens
4. grep found sensitive strings throughout

Solution implemented:

1. **Secrets management**:
   - Moved all API keys to environment variables
   - Build command: flutter build --dart-define=API_KEY=$KEY
   - CI/CD stores secrets securely

2. **Secure storage**:
   - Migrated to flutter_secure_storage
   - Implemented encryption for sensitive local data
   - Added biometric protection for sensitive operations

3. **Obfuscation**:
   - Enabled --obfuscate flag
   - Configured ProGuard rules carefully
   - Stored mapping files with each release
   - Uploaded to Crashlytics

4. **Logging cleanup**:
   - Created AppLogger that's no-op in production
   - Sanitization function for error reporting
   - Audit of all log statements

5. **Size optimization**:
   - Removed 5 unused packages
   - Compressed images (80MB -> 25MB in assets alone)
   - Split APKs by ABI
   - Final size: 28MB (65% reduction)

Results:
- Passed security re-audit
- No sensitive data in decompiled code
- Crashes still readable via Crashlytics
- User complaints about size eliminated
- App store ranking improved
```

---

## 8. Anti-Patterns to Avoid

### 8.1 Hardcoded Secrets
```dart
// INCORRECT: Secrets in source code
const apiKey = 'sk_live_abc123def456';
const dbPassword = 'super_secret_pass';

// CORRECT: Environment variables
const apiKey = String.fromEnvironment('API_KEY');
// Set at build time: --dart-define=API_KEY=value
```

### 8.2 Plain Text Storage
```dart
// INCORRECT: SharedPreferences for sensitive data
await prefs.setString('auth_token', token);

// CORRECT: Encrypted storage
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

### 8.3 Debug Logs in Production
```dart
// INCORRECT: Always logging
print('User data: $userData');
debugPrint('Token: $token');

// CORRECT: Debug-only logging
if (kDebugMode) {
  developer.log('Debug info');
}
```

---

## 9. Additional Resources

### Official Documentation
- [Flutter App Size](https://docs.flutter.dev/perf/app-size)
- [Obfuscating Dart Code](https://docs.flutter.dev/deployment/obfuscate)
- [ProGuard Manual](https://www.guardsquare.com/manual/home)

### Security Resources
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)

### Project References
- Alexandria: Obfuscation and Minification - mobile
- LearnWorlds: Obfuscation and Minification - mobile
- Toolkit for agentive minification and obfuscation configuration

---

## 10. Compliance Evidence

To validate compliance with this requirement, document:

| Evidence | Description |
|----------|-------------|
| Build logs | Showing --obfuscate flag used |
| Mapping files | Stored in secure location |
| Size comparison | Before/after optimization |
| Security scan | No secrets in decompiled code |
| Permission audit | Only necessary permissions |

---

**Last update:** December 2024
**Author:** Architecture Team
**Version:** 1.0.0
