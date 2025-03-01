import 'dart:typed_data';

import 'package:web3dart/crypto.dart';

/// Hashes the ethereum [domain] name
String hashDomainName(String domain) {
  domain = domain.toLowerCase();

  var result = List<int>.filled(32, 0);

  final terms = domain.split(".");

  for (String strTerm in terms.reversed) {
    final bytes = result + keccakUtf8(strTerm);
    final bytesHashed = keccak256(Uint8List.fromList(bytes));
    result = bytesHashed.toList();
  }
  return "0x${bytesToHex(result)}";
}