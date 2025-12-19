/// Minimal abstraction for secure key-value storage.
///
/// Used to avoid depending directly on concrete storage implementations.
abstract interface class SecureKeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

