import 'dart:convert';
import 'dart:typed_data';

import 'package:big_decimal/big_decimal.dart';
import 'package:convert/convert.dart';
import 'package:dart_wif/dart_wif.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:web3dart/crypto.dart';

class WalletMethodUtils {
  static var NEW_PREFIX = "NEW";

  /// concatKeyPairToB58SecretKey for solana.
  /// [privateKey] solana private key hex string.
  /// [publicKey] solana public key hex string
  static String concatKeyPairToB58SecretKey(String privateKey, String publicKey) {
    var secretKey = "${strip0x(privateKey)}${strip0x(publicKey)}";
    return Base58.base58EncodeNoCheck(secretKey.toUint8List());
  }

  /// getPrivateKeyFromB58SecretKey, for import solana private key
  /// [secretKeyB58] eg: 5AhLnfk6HhnaJyNp55yrzY7rwhH8SUMG33DZg3HhbjjY3ADcbzCKoWehPBw8zrScoCr9F9T6Lc2CdQyQKBhhXq2L
  static String getPrivateKeyFromB58SecretKey(String secretKeyB58) {
    var secretKey = Base58.base58DecodeNoCheck(secretKeyB58);
    var secretKeyHex = strip0x(hex.encode(secretKey!.toList()));
    return secretKeyHex.substring(0, 64);
  }

  /// check solana base58 private key + public key
  /// [secretKeyB58] eg: 5AhLnfk6HhnaJyNp55yrzY7rwhH8SUMG33DZg3HhbjjY3ADcbzCKoWehPBw8zrScoCr9F9T6Lc2CdQyQKBhhXq2L
  static bool isValidSolanaPrivateKeyB58(String secretKeyB58) {
    try {
      var secretKey = Base58.base58DecodeNoCheck(secretKeyB58);
      var secretKeyHex = strip0x(hex.encode(secretKey!.toList()));
      return secretKeyHex.length == 128;
    } catch (e) {
      return false;
    }
  }

  // x: bigint number string
  // y: bigint number string
  static String generateAddressByPublicKey(String xPoint, String yPoint, int coinType) {
    var x = BigDecimal.parse(xPoint).toBigInt();
    var y = BigDecimal.parse(yPoint).toBigInt();
    // for eth
    var p = "04${x.toRadixString(16)}${y.toRadixString(16)}";
    final _data = TWData.TWDataCreateWithBytes(p.toUint8List().toPointerUint8(), p.toUint8List().length);
    var pub = PublicKey.createWithData(_data, TWPublicKeyType.TWPublicKeyTypeSECP256k1Extended);
    TWData.TWDataDelete(_data);
    var add = AnyAddress.createWithPublicKey(pub, coinType);
    return add.description().toString();
  }

  static String encodeWIFPrivateKey(String privateKey, {int coinType = TWCoinType.TWCoinTypeBitcoin}) {
    int version = 128;
    if (coinType == TWCoinType.TWCoinTypeBitcoin) {
      version = 128;
    } else if (coinType == TWCoinType.TWCoinTypeDogecoin) {
      version = 158;
    } else if (coinType == TWCoinType.TWCoinTypeLitecoin) {
      version = 176;
    } else if (coinType == TWCoinType.TWCoinTypeDash) {
      version = 204;
    } else if (coinType == TWCoinType.TWCoinTypeBitcoinTestnet) {
      version = 239;
    }
    WIF decoded = WIF(version: version, privateKey: privateKey.toUint8List(), compressed: true);
    return wif.encode(decoded);
  }

  static bool isValidKeyStore(String keyStore) {
    try {
      var keyStoreObject = jsonDecode(keyStore);
      var version = keyStoreObject['version'];
      var id = keyStoreObject['id'];
      var crypto = keyStoreObject['crypto'];
      crypto ??= keyStoreObject['Crypto'];
      return version != null && id != null && crypto != null;
    } catch (e) {
      ABLogger.e("invalid keystore: ${e.toString()}");
      return false;
    }
  }

  /// [privateKeyHex] privateKey Hex string.
  /// [coinType] ([TWCoinType])
  static bool isValidPrivateKey(String privateKeyHex, int coinType) {
    try {
      return PrivateKey.isValid(privateKeyHex.toUint8List(), TWCoinType.TWCoinTypeCurve(coinType));
    } catch (e) {
      ABLogger.e("invalid private key: ${e.toString()}");
      return false;
    }
  }

  static String hexToNewAddress(String address, int chainId) {
    address = address.trim();
    if (address.startsWith(NEW_PREFIX)) {
      return address;
    }
    if (address.startsWith("0x")) {
      address = address.substring(2);
    }
    if (address.length != 40) {
      throw "invalid address: $address";
    }
    var hexChainId = chainId.toRadixString(16);
    if (hexChainId.length - 8 > 0) {
      hexChainId = hexChainId.substring(hexChainId.length - 8);
    }
    var data = hexChainId + address;
    if (data.length % 2 != 0) {
      data = "0$data";
    }
    // 前面的 00 为 version
    data = "00$data";
    var res = NEW_PREFIX + Base58.base58Encode(data.toUint8List());
    return res;
  }
}
