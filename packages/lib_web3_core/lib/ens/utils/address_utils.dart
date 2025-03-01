import 'package:web3dart/crypto.dart';

/// Returns case sensitive checksummed version of Ethereum address
String? hexToAddress(String hexHash) {
  hexHash = hexHash.replaceFirst(RegExp(r'^0x'), '');

  if (hexHash.length != 64) return null;

  var addressDigits = hexHash.substring(24).toLowerCase();
  final chars = addressDigits.split('');
  final hashed = keccakUtf8(addressDigits);

  for (int i = 0; i < 40; i += 2) {
    if ((hashed[i >> 1] >> 4) >= 8) {
      chars[i] = addressDigits[i].toUpperCase();
    }
    if ((hashed[i >> 1] & 0x0f) >= 8) {
      chars[i + 1] = addressDigits[i + 1].toUpperCase();
    }
  }

  return "0x${chars.join()}";
}