import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:lib_base/logger/ab_logger.dart';
import 'package:lib_web3_core/interface/wallet_method_interface.dart';
import 'package:lib_web3_core/model/export_private_key_model.dart';
import 'package:lib_web3_core/model/wallet_account_model.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'dart:convert';

import 'package:lib_web3_core/utils/wallet_method_util.dart';

exportKeyStore(ExportPrivateKeyParams params) async {
  // var wallet = Wallet.createNew(EthPrivateKey.fromHex(params.privateKeyHex),
  //     params.password, Random.secure(),
  //     scryptN: 262144);//默认大小 8192
  // var result = wallet.toJson();
  FlutterTrustWalletCore.init();
  var storeKey = StoredKey.importPrivateKey(
    params.privateKeyHex.toUint8List(),
    "name",
    params.password,
    TWCoinType.TWCoinTypeEthereum,
  );
  var res = storeKey!.exportJson();
  var json = jsonDecode(res!);
  var keystore = {"version": 3, "id": json['id'], "crypto": json['crypto']};
  return Future(() => jsonEncode(keystore));
}

class WalletMethod extends WalletMethodInterface {
  /// singleton
  WalletMethod._internal();

  static final WalletMethod instance = WalletMethod._internal();

  factory WalletMethod() {
    return instance;
  }

  @override
  Future<WalletAccountModel> createAccountByKeystore({
    required String keystore,
    required String password,
    required int coinType,
  }) {
    if (coinType == TWCoinTypeExtension.TWCoinTypeGateNativeChain) {
      ABLogger.e("gate native chain not support keystore");
      throw "gate native chain not support keystore";
    }
    var storedKey = StoredKey.importJson(keystore);
    if (storedKey == null) {
      ABLogger.e("importKeyStore error: not import success");
      throw "importKeyStore error: not import success";
    }
    Uint8List? privateKey;
    try {
      privateKey = storedKey.decryptPrivateKey(password.utf8Encode());
      if (privateKey == null) {
        throw "privateKey error: not private";
      }
      var prv = PrivateKey.createWithData(privateKey);
      var publicKey = prv.getPublicKey(TWCoinType.TWCoinTypeCurve(coinType), _isCompressedPubkey(coinType));
      var address = AnyAddress.createWithPublicKey(publicKey, coinType);
      var chainKey = CoinTypeConfiguration.getSymbol(coinType);
      var model = WalletAccountModel(
        chainKey,
        0,
        address.description(),
        hex.encode(prv.data()),
        hex.encode(publicKey.data()),
        "",
        "",
        "",
        _getWrokAroundDerivationPath(coinType),
      );
      model.extendKey(coinType);
      return Future.value(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WalletAccountModel> createAccountByMnemonicAndType({required String mnemonic, required int coinType}) {
    var hdWallet = HDWallet.createWithMnemonic(formatMnemonic(mnemonic));
    return Future.value(_wrapAccountModel(hdWallet, coinType));
  }

  @override
  Future<WalletAccountModel> createAccountByPrivateKeyAndType({required String privateKeyHex, required int coinType}) {
    if (privateKeyHex.toLowerCase().startsWith("0x")) {
      privateKeyHex = privateKeyHex.substring(2);
    }
    var privateKey = PrivateKey.createWithData(privateKeyHex.toUint8List());
    var publicKey = privateKey.getPublicKey(TWCoinType.TWCoinTypeCurve(coinType), _isCompressedPubkey(coinType));
    var address = AnyAddress.createWithPublicKey(publicKey, coinType);
    var chainKey = CoinTypeConfiguration.getSymbol(coinType);
    var model = WalletAccountModel(
      chainKey,
      0,
      address.description(),
      privateKeyHex,
      hex.encode(publicKey.data()),
      "",
      "",
      "",
      _getWrokAroundDerivationPath(coinType),
    );
    model.extendKey(coinType);
    return Future.value(model);
  }

  @override
  Future<WalletAccountModel> createAccountsByExtenedPrivateKey({
    required String extenedPrivateKey,
    required String derivationPath,
    required int coinType,
    required int position,
    int? deriveIndex,
  }) {
    // derivation privateKey by extended private key
    bool hasFlag = _checkHaveExtendedPrivateKey(coinType);
    PrivateKey privateKey;
    if (hasFlag) {
      // have extended private key
      privateKey = PrivateKey.getPrivateKeyFromExtended(extenedPrivateKey, coinType, derivationPath);
    } else {
      // have not extended private key, use chain code & key
      var map = json.decode(extenedPrivateKey) as Map<String, dynamic>;
      var chainCode = map['chainCode']!.toString();
      var key = map['key']!.toString();
      if (coinType == TWCoinType.TWCoinTypeCardano) {
        var extension = map['extension']!.toString();
        privateKey = PrivateKey.getPrivateKeyByChainCodeCardano(key, extension, chainCode, coinType, derivationPath);
      } else {
        privateKey = PrivateKey.getPrivateKeyByChainCode(chainCode, key, coinType, derivationPath);
      }
    }
    var publicKey = privateKey.getPublicKey(TWCoinType.TWCoinTypeCurve(coinType), _isCompressedPubkey(coinType));
    var address = AnyAddress.createWithPublicKey(publicKey, coinType);
    var chainKey = CoinTypeConfiguration.getSymbol(coinType);
    var accountAddress = address.description();
    var accountPrivateKey = hex.encode(privateKey.data());
    var accountPublicKey = hex.encode(publicKey.data());
    var model = WalletAccountModel(
      chainKey,
      position,
      accountAddress,
      accountPrivateKey,
      accountPublicKey,
      "",
      "",
      derivationPath,
      _getWrokAroundDerivationPath(coinType),
    );
    model.extendKey(coinType);
    return Future.value(model);
  }

  @override
  Future<List<WalletAccountModel>> createAccountsByMnemonicAndTypes({
    required String mnemonic,
    required List<int> coinTypes,
  }) async {
    var list = <WalletAccountModel>[];
    for (var coinType in coinTypes) {
      var model = await createAccountByMnemonicAndType(mnemonic: mnemonic, coinType: coinType);
      list.add(model);
    }
    return list;
  }

  @override
  Future<List<WalletAccountModel>> createAccountsByPrivateKeyAndTypes({
    required String privateKeyHex,
    required List<int> coinTypes,
  }) async {
    var list = <WalletAccountModel>[];
    for (var coinType in coinTypes) {
      var model = await createAccountByPrivateKeyAndType(privateKeyHex: privateKeyHex, coinType: coinType);
      list.add(model);
    }
    return list;
  }

  @override
  Future<String> exportKeysotreByPrivateKey({required String privateKeyHex, required String password}) async {
    var params = ExportPrivateKeyParams(privateKeyHex: privateKeyHex, password: password);
    var keystore = await compute(exportKeyStore, params) as String;
    return keystore;
  }

  /// CS = ENT / 32
  /// MS = (ENT + CS) / 11
  /// |  ENT  | CS | ENT+CS |  MS  |
  /// +-------+----+--------+------+
  /// |  128  |  4 |   132  |  12  |
  /// |  160  |  5 |   165  |  15  |
  /// |  192  |  6 |   198  |  18  |
  /// |  224  |  7 |   231  |  21  |
  /// |  256  |  8 |   264  |  24  |
  @override
  String generateMnemonic({int wordNumber = 12}) {
    var hdWallet = HDWallet(strength: _getMnemonicStrengthByWordNumber(wordNumber));
    return hdWallet.mnemonic();
  }

  int _getMnemonicStrengthByWordNumber(int wordNumber) {
    switch (wordNumber) {
      case 12:
        return 128;
      case 15:
        return 160;
      case 18:
        return 192;
      case 21:
        return 224;
      case 24:
        return 256;
      default:
        return 128;
    }
  }

  /// 格式化助记词
  String formatMnemonic(String mnemonic) {
    var list = mnemonic.trim().split(" ");
    var words = [];
    for (var element in list) {
      if (element.isNotEmpty) {
        words.add(element.trim());
      }
    }
    var res = "";
    for (var element in words) {
      res += " $element";
    }
    return res.trim();
  }

  WalletAccountModel _wrapAccountModel(HDWallet hdWallet, int coinType) {
    var accountAddress = "";
    if (coinType == TWCoinTypeExtension.TWCoinTypeNewChainDevnet ||
        coinType == TWCoinTypeExtension.TWCoinTypeNewChainTestnet) {
      accountAddress = hdWallet.getAddressForCoin(TWCoinType.TWCoinTypeNewChain);
      accountAddress = formatAddress(address: accountAddress, coinType: coinType);
      coinType = TWCoinType.TWCoinTypeNewChain;
    } else {
      accountAddress = hdWallet.getAddressForCoin(coinType);
      accountAddress = formatAddress(address: accountAddress, coinType: coinType);
    }
    var privateKey = hdWallet.getKeyForCoin(coinType);
    var accountPrivateKey = hex.encode(privateKey.data());
    var publicKey = privateKey.getPublicKey(TWCoinType.TWCoinTypeCurve(coinType), _isCompressedPubkey(coinType));
    var accountPublicKey = hex.encode(publicKey.data());
    // check hd version
    var xprv = TWCoinType.TWCoinTypeXprvVersion(coinType);
    var xpub = TWCoinType.TWCoinTypeXpubVersion(coinType);
    var purpose = TWCoinType.TWCoinTypePurpose(coinType);
    var accountExtendedPrivateKey = "";
    var accountExtendedPublicKey = "";
    if (_checkHaveExtendedPrivateKey(coinType)) {
      // have extended privateKey
      accountExtendedPrivateKey = hdWallet.getExtendedPrivateKey(
        purpose,
        coinType,
        xprv == TWHDVersion.TWHDVersionNone ? TWHDVersion.TWHDVersionXPRV : xprv,
      );
      accountExtendedPublicKey = hdWallet.getExtendedPublicKey(
        purpose,
        coinType,
        xpub == TWHDVersion.TWHDVersionNone ? TWHDVersion.TWHDVersionXPUB : xpub,
      );
    } else {
      // have not extended private key, get chain code and key.
      accountExtendedPrivateKey = _getZeroDeepthChainCodeKeyString(hdWallet.mnemonic(), coinType);
    }
    var accountPosition = 0;
    var extenedPath = CoinTypeConfiguration.getDerivatePath(coinType);
    var chainKey = CoinTypeConfiguration.getSymbol(coinType);
    var model = WalletAccountModel(
      chainKey,
      accountPosition,
      accountAddress,
      accountPrivateKey,
      accountPublicKey,
      accountExtendedPrivateKey,
      accountExtendedPublicKey,
      extenedPath,
      _getWrokAroundDerivationPath(coinType),
    );
    model.extendKey(coinType);
    return model;
  }

  /// 格式化地址，防止有些地址返回值不规范
  String formatAddress({required String address, required int coinType}) {
    switch (coinType) {
      case TWCoinType.TWCoinTypeAptos:
        var temp = address.split0x();
        var len = 64 - temp.length;
        return '0x${"0" * len}$temp';
      case TWCoinType.TWCoinTypeNewChain:
        return WalletMethodUtils.hexToNewAddress(address, 1012);
      case TWCoinTypeExtension.TWCoinTypeNewChainDevnet:
        return WalletMethodUtils.hexToNewAddress(address, 1002);
      case TWCoinTypeExtension.TWCoinTypeNewChainTestnet:
        return WalletMethodUtils.hexToNewAddress(address, 1007);
      default:
        return address;
    }
  }

  bool _isCompressedPubkey(int coinType) {
    var publicKeyType = TWCoinType.TWCoinTypePublicKeyType(coinType);
    if (publicKeyType == TWPublicKeyType.TWPublicKeyTypeSECP256k1 ||
        publicKeyType == TWPublicKeyType.TWPublicKeyTypeNIST256p1) {
      return true;
    } else {
      return false;
    }
  }

  bool _checkHaveExtendedPrivateKey(int coinType) {
    var curve = TWCoinType.TWCoinTypeCurve(coinType);
    return curve == TWCurve.TWCurveSECP256k1 || curve == TWCurve.TWCurveNIST256p1;
  }

  String _getZeroDeepthChainCodeKeyString(String mnemonic, int coinType) {
    if (coinType == TWCoinType.TWCoinTypeCardano) {
      var node = HDWallet.getHDNodeCardano(mnemonic, coinType, _getZeroDeepthDerivationPath(coinType)).split(",");
      if (node.length < 3) {
        return "";
      }
      var key = node[0];
      var ext = node[1];
      var chainCode = node[2];
      var map = {"chainCode": chainCode, "key": key, "extension": ext};
      return json.encode(map);
    } else {
      var node = HDWallet.getHDNode(mnemonic, coinType, _getZeroDeepthDerivationPath(coinType)).split(",");
      if (node.length < 2) {
        return "";
      }
      var chainCode = node[0];
      var key = node[1];
      var map = {"chainCode": chainCode, "key": key};
      return json.encode(map);
    }
  }

  String _getZeroDeepthDerivationPath(int coinType) {
    if (coinType == TWCoinType.TWCoinTypeCardano) {
      return "m/1852'/1815'";
    }
    var purpose = TWCoinType.TWCoinTypePurpose(coinType);

    ///非全路径
    // move 的扩展私钥路径和 aptos 的一致
    // switch (coinType) {
    //   case TWCoinType.TWCoinTypeMove:
    //     coinType = TWCoinType.TWCoinTypeAptos;
    //   case TWCoinType.TWCoinTypeSonic:
    //     coinType = TWCoinType.TWCoinTypeSolana;
    // }
    var res = "m/$purpose'/$coinType'";
    return res;
  }

  String _getWrokAroundDerivationPath(int coinType) {
    var res = "";
    switch (coinType) {
      case TWCoinType.TWCoinTypeEthereum:
        {
          res = "m/44'/60'/0'";
        }
        break;
      case TWCoinType.TWCoinTypeSolana:
        {
          res = "m/44'/501'";
        }
        break;

      default:
        {
          res = CoinTypeConfiguration.getDerivatePath(coinType);
        }
        break;
    }
    return res;
  }

  @override
  Future<WalletAccountModel> createAccountsByExtenedPublicKey({
    required String extenedPublicKey,
    required int coinType,
    required int position,
    int? deriveIndex,
  }) {
    var derivationPath = WalletMethodUtils.getDerivationPathByCoinType(coinType: coinType, index: position);
    var publicKey = PublicKey.getPublicKeyFromExtended(extenedPublicKey, coinType, derivationPath);
    var address = AnyAddress.createWithPublicKey(publicKey, coinType);
    var chainKey = CoinTypeConfiguration.getSymbol(coinType);
    var accountAddress = address.description();
    accountAddress = formatAddress(address: accountAddress, coinType: coinType);
    var accountPublicKey = hex.encode(publicKey.data());
    var model = WalletAccountModel(
      chainKey,
      position,
      accountAddress,
      "",
      accountPublicKey,
      "",
      extenedPublicKey,
      derivationPath,
      _getWrokAroundDerivationPath(coinType),
    );
    model.extendKey(coinType);
    return Future.value(model);
  }
}
