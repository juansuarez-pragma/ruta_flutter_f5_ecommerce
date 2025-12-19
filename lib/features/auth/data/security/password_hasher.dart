import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Hasher abstraction for passwords.
abstract interface class PasswordHasher {
  Future<PasswordHash> hash(String password);
  Future<bool> verify(String password, PasswordHash expected);
}

/// Serializable password hash data.
final class PasswordHash {
  const PasswordHash({
    required this.algorithm,
    required this.iterations,
    required this.saltBase64,
    required this.hashBase64,
  });

  factory PasswordHash.fromJson(Map<String, dynamic> json) {
    return PasswordHash(
      algorithm: json['algorithm'] as String,
      iterations: json['iterations'] as int,
      saltBase64: json['salt'] as String,
      hashBase64: json['hash'] as String,
    );
  }

  final String algorithm;
  final int iterations;
  final String saltBase64;
  final String hashBase64;

  Map<String, dynamic> toJson() => {
    'algorithm': algorithm,
    'iterations': iterations,
    'salt': saltBase64,
    'hash': hashBase64,
  };
}

/// PBKDF2 implementation using HMAC-SHA256.
final class Pbkdf2PasswordHasher implements PasswordHasher {
  Pbkdf2PasswordHasher({
    int iterations = 150000,
    int saltBytes = 16,
    int derivedKeyBytes = 32,
  }) : _iterations = iterations,
       _saltBytes = saltBytes,
       _derivedKeyBytes = derivedKeyBytes;

  static const String _algorithmName = 'PBKDF2-HMAC-SHA256';
  final int _iterations;
  final int _saltBytes;
  final int _derivedKeyBytes;

  @override
  Future<PasswordHash> hash(String password) async {
    final salt = _randomBytes(_saltBytes);
    final hashBytes = await _deriveKey(
      password: password,
      salt: salt,
      iterations: _iterations,
      derivedKeyBytes: _derivedKeyBytes,
    );

    return PasswordHash(
      algorithm: _algorithmName,
      iterations: _iterations,
      saltBase64: base64Encode(salt),
      hashBase64: base64Encode(hashBytes),
    );
  }

  @override
  Future<bool> verify(String password, PasswordHash expected) async {
    if (expected.algorithm != _algorithmName) return false;

    final salt = base64Decode(expected.saltBase64);
    final expectedHash = base64Decode(expected.hashBase64);

    final actualHash = await _deriveKey(
      password: password,
      salt: salt,
      iterations: expected.iterations,
      derivedKeyBytes: expectedHash.length,
    );

    return _constantTimeEquals(actualHash, expectedHash);
  }

  Future<Uint8List> _deriveKey({
    required String password,
    required Uint8List salt,
    required int iterations,
    required int derivedKeyBytes,
  }) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: derivedKeyBytes * 8,
    );

    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    final bytes = await secretKey.extractBytes();
    return Uint8List.fromList(bytes);
  }

  Uint8List _randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
