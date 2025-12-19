import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architecture: auth storage security', () {
    test(
      'auth feature does not depend on SharedPreferences outside migration',
      () {
        final authRoot = Directory('lib/features/auth');
        expect(
          authRoot.existsSync(),
          isTrue,
          reason: 'Expected to run tests from the project root.',
        );

        final allowedFiles = <String>{
          // Allowed: migration reads/removes legacy SharedPreferences values.
          'lib/features/auth/data/datasources/auth_local_datasource_impl.dart',
        };

        final offenders = <String>[];

        final dartFiles = authRoot
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

        for (final file in dartFiles) {
          final normalizedPath = file.path.replaceAll('\\', '/');
          if (allowedFiles.contains(normalizedPath)) continue;

          final content = file.readAsStringSync();
          if (content.contains('package:shared_preferences/shared_preferences.dart')) {
            offenders.add(normalizedPath);
          }
        }

        expect(
          offenders,
          isEmpty,
          reason:
              'Production-grade auth must not depend on SharedPreferences.\n'
              'Use SecureKeyValueStore (secure storage) instead.\n'
              'Offenders:\n${offenders.join('\n')}',
        );
      },
    );

    test(
      'auth legacy SharedPreferences is not used for writing secrets',
      () {
        final file = File(
          'lib/features/auth/data/datasources/auth_local_datasource_impl.dart',
        );
        expect(
          file.existsSync(),
          isTrue,
          reason: 'Expected auth datasource file to exist.',
        );

        final content = file.readAsStringSync();

        // The legacy shared preferences instance should only be used for:
        // - reading legacy values (getString)
        // - deleting legacy values after migration (remove)
        //
        // It must not write secrets back to SharedPreferences.
        expect(
          content.contains('_legacySharedPreferences.setString('),
          isFalse,
          reason:
              'Do not store auth data in SharedPreferences. Use SecureKeyValueStore.',
        );
      },
    );
  });
}
