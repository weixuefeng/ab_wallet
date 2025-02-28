import 'dart:convert';
import 'dart:typed_data';

import 'package:big_decimal/big_decimal.dart';
import 'package:convert/convert.dart';
import 'package:dart_bech32/dart_bech32.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

/// list extension
extension ListExtension on List {
  toPrettyString() {
    String res = "[";
    for (var i = 0; i < length; i++) {
      res += "${elementAt(i)},";
    }
    res.substring(res.length - 1, res.length);
    res += "]";
    return res;
  }
}

/// string extension
extension StringExtension on String {
  String append0x() {
    // 检查字符串是否为空或以 '0x' 开头
    if (startsWith('0x')) {
      return this;
    } else {
      return '0x${this}';
    }
  }

  BigInt lehexToU128() {
    Uint8List bytes = this.toUint8List();
    String beHex = '0x${bytes.reversed.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('')}';
    if (beHex == "0x") {
      return BigInt.zero;
    }
    return BigInt.parse(beHex);
  }

  /// IoTex链0x开头地址转换为io开头地址
  String toIoTexAddress() {
    final ioAddress = bech32.encode(Decoded(prefix: 'io', words: bech32.toWords(toUint8List())));
    return ioAddress;
  }

  /// IoTex链io开头地址转换为0x开头地址
  String toEthereumAddress() {
    // final decoded1 = bech32.decode('io1xce5w60gju6qzxgct57g5f7dllltun2cyup892');
    // final res = bech32.fromWords(decoded1.words);
    try {
      final decoded = bech32.decode(this);
      final words = bech32.fromWords(decoded.words);
      final ethereumAddress = words.toHex();
      return ethereumAddress;
    } catch (error) {
      return '';
    }
  }

  Uint8List toUint8List() {
    List<int> data = hex.decode(formatHex());
    return Uint8List.fromList(data);
  }

  bool isHex() {
    try {
      hex.decode(formatHex());
      return true;
    } catch (e) {
      return false;
    }
  }

  String formatBtcPublicKeyForBabylon() {
    String result = this.split0x();
    if (result.length > 64) {
      return result.substring(result.length - 64);
    } else {
      return result;
    }
  }

  formatHex() {
    var result = strip0x(this);
    if (result.length % 2 != 0) {
      result = "0$result";
    }
    return result;
  }

  Uint8List utf8Encode() {
    return Uint8List.fromList(utf8.encode(this));
  }

  toWei(int pow) {
    return (BigDecimal.parse(this) * BigDecimal.fromBigInt(BigInt.from(10).pow(pow))).toBigInt();
  }

  include0x() {
    if (!startsWith("0x")) {
      return "0x$this";
    } else {
      return this;
    }
  }

  String split0x() {
    if (startsWith("0x")) {
      return substring(2);
    } else {
      return this;
    }
  }

  String tron2HexAddress() {
    if (startsWith("T")) {
      return bytesToHex(Base58.base58Decode(this)!).substring(2);
    } else {
      return this;
    }
  }

  String unemojify() {
    if (isEmpty) return this;
    var parser = EmojiParser();
    final characters = Characters(this);
    final buffer = StringBuffer();
    for (final character in characters) {
      if (parser.hasEmoji(character)) {
        var result = character;
        result = result.replaceAll(character, parser.getEmoji(character).name);

        buffer.write(result);
      } else {
        buffer.write(character);
      }
    }
    return buffer.toString();
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }

  /// [beforeLength] 前缀截取长度
  /// [afterLength] 后缀截取长度
  String toSeparate({int beforeLength = 6, int afterLength = 4}) {
    if (length < (beforeLength + afterLength)) return this;
    return '${substring(0, beforeLength)}...${substring(length - afterLength, length)}';
  }

  /// 转化为空格字符串
  /// Text在使用FittedBox包裹时不能为空串
  String toWhitespace() {
    if (isEmpty) {
      return ' ';
    }
    return this;
  }

  /// 移除小数点后的尾随零
  String removeTrailingZeros() {
    var str = this;
    if (contains('.')) {
      str = str.replaceAll(RegExp(r'0*$'), ''); // 去除尾随的零
      str = str.replaceAll(RegExp(r'\.$'), ''); // 如果小数点后没有数字了，也去除小数点
    }
    return str;
  }

  String toCheckSumAddress() {
    return EthereumAddress.fromHex(this).hexEip55;
  }
}

/// bigint extension
extension BigintExtension on BigInt {
  toUint8List() {
    String numStr = toRadixString(16);
    if (numStr.length % 2 != 0) {
      numStr = "0$numStr";
    }
    return numStr.toUint8List();
  }

  String u128ToLe() {
    // 将 BigInt 转换为 16 进制字符串，并用 '0' 补齐到 32 个字符
    String hexString = toRadixString(16).padLeft(32, '0');

    // 将 16 进制字符串分成 8 个字节，并按小端顺序排列
    List<String> bytes = [];
    for (int i = 0; i < 32; i += 2) {
      bytes.add(hexString.substring(i, i + 2));
    }

    // 反转字节顺序以实现小端格式
    bytes = bytes.reversed.toList();

    // 将字节列表连接成一个字符串
    return bytes.join('');
  }
}

/// int extension
extension IntExtension on int {
  toUint8List() {
    String numStr = toRadixString(16);
    if (numStr.length % 2 != 0) {
      numStr = "0$numStr";
    }
    return numStr.toUint8List();
  }

  toBytes() {
    if (this < 0) {
      throw ArgumentError("Negative numbers not supported");
    }
    final byteData = ByteData(8); // Assuming a 32-bit integer
    byteData.setInt64(0, this, Endian.big);
    return byteData.buffer.asUint8List().toList();
  }
}

extension Uint8Extension on Uint8List {
  String toHex() {
    var res = hex.encode(this);
    if (res.startsWith("0x")) {
      return res;
    }
    return "0x$res";
  }
}

extension MapExtension on Map<String, dynamic> {
  Uint8List toUint8List() {
    List<int> list = [];
    forEach((key, value) {
      list.add(value);
    });
    return Uint8List.fromList(list);
  }
}

extension TWCoinTypeExtension on TWCoinType {
  static const int TWCoinTypeGateNativeChain = 10000186;
  static const int TWCoinTypeFilecoinEVMChain = 10000461;
  static const int TWCoinTypeAleoNetwork = 999999999;
  static const int TWCoinTypeQuai = 994;
  static const int TWCoinTypeStarkNet = 9004;
  static const int TWCoinTypeKaspa = 111111;
  static const int TWCoinTypeNewChainTestnet = 10001642;
  static const int TWCoinTypeNewChainDevnet = 20001642;
}

extension DoubleExtension on double {
  String removeTrailingZeros() {
    return toString().removeTrailingZeros();
  }
}

// Uint8List readList(ton.Slice slice) {
//   if (slice.remainingBits % 8 != 0) {
//     throw 'Invalid string length: ${slice.remainingBits}';
//   }
//   if (slice.remainingRefs != 0 && slice.remainingRefs != 1) {
//     throw 'Invalid number of references: ${slice.remainingRefs}';
//   }
//   if (slice.remainingRefs == 1 && (1023 - slice.remainingBits) > 7) {
//     throw 'Invalid string length: ${slice.remainingBits / 8}';
//   }

//   Uint8List res;
//   if (slice.remainingBits == 0) {
//     res = Uint8List(0);
//   } else {
//     res = slice.loadList(slice.remainingBits ~/ 8);
//   }

//   if (slice.remainingRefs == 1) {
//     var bb = BytesBuilder();
//     bb.add(res);
//     bb.add(readList(slice.loadRef().beginParse()));

//     res = bb.takeBytes();
//   }

//   return res;
// }
