import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architecture: DI boundaries (GetIt)', () {
    test('GetIt (sl<...>) is used only in composition points', () {
      final libRoot = Directory('lib');
      expect(
        libRoot.existsSync(),
        isTrue,
        reason: 'Expected to run tests from the project root.',
      );

      final allowedPrefixes = <String>[
        'lib/core/di/',
        'lib/core/router/',
        'lib/app.dart',
      ];

      final dartFiles = libRoot
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

      final offenders = <String>[];

      for (final file in dartFiles) {
        final normalizedPath = file.path.replaceAll('\\', '/');
        final isAllowed = allowedPrefixes.any(
          (prefix) => normalizedPath.startsWith(prefix),
        );
        if (isAllowed) continue;

        final content = file.readAsStringSync();
        if (content.contains('sl<') || content.contains('sl(')) {
          offenders.add(normalizedPath);
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'Do not use the service locator outside composition points.\n'
            'Move bloc creation and dependency wiring to AppRouter/DI container.\n'
            'Offenders:\n${offenders.join('\n')}',
      );
    });
  });
}

