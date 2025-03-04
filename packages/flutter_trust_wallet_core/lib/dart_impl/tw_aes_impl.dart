import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';

class TwAesImpl extends TWAES {
  static Uint8List encryptCBC(Uint8List key, Uint8List data, Uint8List iv, int mode) {
    final _key = TWData.TWDataCreateWithBytes(key.toPointerUint8(), key.length);
    final _data = TWData.TWDataCreateWithBytes(data.toPointerUint8(), data.length);
    final _iv = TWData.TWDataCreateWithBytes(iv.toPointerUint8(), iv.length);
    var result = TWAES.TWAESEncryptCBC(_key, _data, _iv, mode);
    final r = TWData.TWDataBytes(result).asTypedList(TWData.TWDataSize(result));
    return r;
  }

  static Uint8List decryptCBC(Uint8List key, Uint8List data, Uint8List iv, int mode) {
    final _key = TWData.TWDataCreateWithBytes(key.toPointerUint8(), key.length);
    final _data = TWData.TWDataCreateWithBytes(data.toPointerUint8(), data.length);
    final _iv = TWData.TWDataCreateWithBytes(iv.toPointerUint8(), iv.length);
    var result = TWAES.TWAESDecryptCBC(_key, _data, _iv, mode);
    final r = TWData.TWDataBytes(result).asTypedList(TWData.TWDataSize(result));
    return r;
  }

  static String encryptCTR(String key, String data, String iv) {
    return "";
  }

  static String decryptCTR(String key, String data, String iv) {
    return "";
  }
}
