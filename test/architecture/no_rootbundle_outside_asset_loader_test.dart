import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architecture: framework isolation (assets)', () {
    test('rootBundle is only used inside the AssetStringLoader implementation',
        () {
      final libRoot = Directory('lib');
      expect(
        libRoot.existsSync(),
        isTrue,
        reason: 'Expected to run tests from the project root.',
      );

      final allowedFiles = <String>{
        'lib/core/config/asset_string_loader.dart',
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
        if (content.contains('rootBundle')) {
          offenders.add(normalizedPath);
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'Inject AssetStringLoader instead of using rootBundle directly.\n'
            'Offenders:\n${offenders.join('\n')}',
      );
    });
  });
}

