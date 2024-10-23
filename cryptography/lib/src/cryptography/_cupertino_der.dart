import 'package:cryptography_plus/cryptography_plus.dart';

bool bytesStartsWith(List<int> bytes, List<int> prefix, int index) {
  if (bytes.length < index + prefix.length) {
    return false;
  }
  for (var i = 0; i < prefix.length; i++) {
    if (bytes[index + i] != prefix[i]) {
      return false;
    }
  }
  return true;
}

/// Patterns for DER-encoded ECDH/ECDSA keys generated by the latest version of
/// Apple's CryptoKit.
///
/// Unlike Android, CryptoKit doesn't offer a way to handle ECDH/ECDSA
/// parameters d, x, y directly.
class CupertinoEcDer {
  static const CupertinoEcDer p256 = CupertinoEcDer(
    name: 'P-256',
    numberLength: 32,
    privateKeyPrefix: [
      0x30, 0x81, 0x87, 0x02, 0x01, 0x00, 0x30, 0x13, // 0..7
      0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, // 8..15
      0x01, 0x06, 0x08, 0x2a, 0x86, 0x48, 0xce, 0x3d, // 16..23
      0x03, 0x01, 0x07, 0x04, 0x6d, 0x30, 0x6b, 0x02, // 24..31
      0x01, 0x01, 0x04, 0x20, // 32..34
    ],
    privateKeyMiddle: [0xa1, 0x44, 0x03, 0x42, 0x00, 0x04],
    publicKeyPrefix: [
      0x30, 0x59, 0x30, 0x13, 0x06, 0x07, 0x2a, 0x86, // 0..7
      0x48, 0xce, 0x3d, 0x02, 0x01, 0x06, 0x08, 0x2a, // 8..15
      0x86, 0x48, 0xce, 0x3d, 0x03, 0x01, 0x07, 0x03, // 16..23
      0x42, 0x00, 0x04, // 24..26
    ],
  );

  static const CupertinoEcDer p384 = CupertinoEcDer(
    name: 'P-384',
    numberLength: 48,
    privateKeyPrefix: [
      0x30, 0x81, 0xb6, 0x02, 0x01, 0x00, 0x30, 0x10, // 0..7
      0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, // 8..15
      0x01, 0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x22, // 16..23
      0x04, 0x81, 0x9e, 0x30, 0x81, 0x9b, 0x02, 0x01, // 24..31
      0x01, 0x04, 0x30, // 32..34
    ],
    privateKeyMiddle: [0xa1, 0x64, 0x03, 0x62, 0x00, 0x04],
    publicKeyPrefix: [
      0x30, 0x76, 0x30, 0x10, 0x06, 0x07, 0x2a, 0x86, // 0..7
      0x48, 0xce, 0x3d, 0x02, 0x01, 0x06, 0x05, 0x2b, // 8..15
      0x81, 0x04, 0x00, 0x22, 0x03, 0x62, 0x00, 0x04, // 16..23
    ],
  );
  static const CupertinoEcDer p521 = CupertinoEcDer(
    name: 'P-521',
    numberLength: 66,
    privateKeyPrefix: [
      0x30, 0x81, 0xee, 0x02, 0x01, 0x00, 0x30, 0x10, // 0..7
      0x06, 0x07, 0x2a, 0x86, 0x48, 0xce, 0x3d, 0x02, // 8..15
      0x01, 0x06, 0x05, 0x2b, 0x81, 0x04, 0x00, 0x23, // 16..23
      0x04, 0x81, 0xd6, 0x30, 0x81, 0xd3, 0x02, 0x01, // 24..31
      0x01, 0x04, 0x42, // 32..34
    ],
    privateKeyMiddle: [0xa1, 0x81, 0x89, 0x03, 0x81, 0x86, 0x00, 0x04],
    publicKeyPrefix: [
      0x30, 0x81, 0x9b, 0x30, 0x10, 0x06, 0x07, 0x2a, // 0..7
      0x86, 0x48, 0xce, 0x3d, 0x02, 0x01, 0x06, 0x05, // 8..15
      0x2b, 0x81, 0x04, 0x00, 0x23, 0x03, 0x81, 0x86, // 16..24
      0x00, 0x04,
    ],
  );
  final String name;

  final int numberLength;

  /// In private keys, bytes before parameter `d`.
  final List<int> privateKeyPrefix;

  /// In private keys, bytes before parameters `x` and `y`.
  final List<int> privateKeyMiddle;

  /// In public keys, bytes before parameters `x` and `y`.
  final List<int> publicKeyPrefix;

  const CupertinoEcDer({
    required this.name,
    required this.numberLength,
    required this.privateKeyPrefix,
    required this.privateKeyMiddle,
    required this.publicKeyPrefix,
  });

  static CupertinoEcDer get(KeyPairType keyPairType) {
    if (keyPairType == KeyPairType.p256) {
      return CupertinoEcDer.p256;
    }
    if (keyPairType == KeyPairType.p384) {
      return CupertinoEcDer.p384;
    }
    if (keyPairType == KeyPairType.p521) {
      return CupertinoEcDer.p521;
    }
    throw UnsupportedError('Unsupported key type: $keyPairType');
  }
}
