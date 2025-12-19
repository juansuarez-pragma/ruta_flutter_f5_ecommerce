import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architecture: determinism (Clock)', () {
    test('DateTime.now is only used by SystemClock', () {
      final libRoot = Directory('lib');
      expect(
        libRoot.existsSync(),
        isTrue,
        reason: 'Expected to run tests from the project root.',
      );

      final allowedFiles = <String>{
        'lib/core/utils/clock.dart',
      };

      final dartFiles = libRoot
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

      final offenders = <String>[];

      for (final file in dartFiles) {
        final normalizedPath = file.path.replaceAll('\\', '/');
        if (allowedFiles.contains(normalizedPath)) continue;

        final content = file.readAsStringSync();
        if (content.contains('DateTime.now(')) {
          offenders.add(normalizedPath);
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'Inject Clock instead of calling DateTime.now() directly.\n'
            'Offenders:\n${offenders.join('\n')}',
      );
    });
  });
}

