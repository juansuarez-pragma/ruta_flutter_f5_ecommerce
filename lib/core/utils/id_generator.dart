import 'package:uuid/uuid.dart';

/// Abstraction for generating IDs without coupling callers to a concrete
/// implementation (e.g. UUID, nanoid, database-generated ids).
abstract class IdGenerator {
  String generate();
}

/// Default UUID v4 generator implementation.
class UuidV4Generator implements IdGenerator {
  const UuidV4Generator({Uuid uuid = const Uuid()}) : _uuid = uuid;

  final Uuid _uuid;

  @override
  String generate() => _uuid.v4();
}

