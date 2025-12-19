import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architecture: SRP (domain repositories)', () {
    test(
      'domain repository files do not define Failure types/models',
      () {
        final featureRoot = Directory('lib/features');
        expect(
          featureRoot.existsSync(),
          isTrue,
          reason: 'Expected to run tests from the project root.',
        );

        final repositoryFiles = featureRoot
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) => f.path.contains('${Platform.pathSeparator}domain${Platform.pathSeparator}repositories${Platform.pathSeparator}'))
            .where((f) => f.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

        final forbiddenDefinition = RegExp(
          r'^\s*(enum|class|sealed class)\s+\w*(FailureType|Failure)\b',
          multiLine: true,
        );

        final offenders = <String>[];

        for (final file in repositoryFiles) {
          final content = file.readAsStringSync();
          if (forbiddenDefinition.hasMatch(content)) {
            offenders.add(file.path);
          }
        }

        expect(
          offenders,
          isEmpty,
          reason:
              'Move failures to lib/features/<feature>/domain/failures/ and keep repository files for contracts only.\n'
              'Offenders:\n${offenders.join('\n')}',
        );
      },
    );
  });
}

