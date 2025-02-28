import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';

class WalletAccountModel {
  String chainKey = "";
  int accountPosition = 0;
  String accountAddress = "";
  String accountPrivateKey = "";
  String accountPublicKey = "";
  String accountExtendedPrivateKey = "";
  String accountExtendedPublicKey = "";
  String extendedPath = "";

  // workaround for gate old data
  String accountPath = "";

  // btc wip private key
  String? wipPrivateKey = "";

  // solana secrect key = privateKey + publickkey encode with base 58
  String? secretKey = "";

  // substrate
  String? seed = "";

  String? accountFormat;

  // cosmos 系列字段
  String? denom;
  String? hrp;

  // 真实的账户派生index， 目前只有quai用到， 其他链还是直接用accountPosition
  int? accountDeriveIndex;

  WalletAccountModel(
    this.chainKey,
    this.accountPosition,
    this.accountAddress,
    this.accountPrivateKey,
    this.accountPublicKey,
    this.accountExtendedPrivateKey,
    this.accountExtendedPublicKey,
    this.extendedPath,
    this.accountPath, {
    this.wipPrivateKey,
    this.secretKey,
    this.seed,
    this.accountFormat,
    this.accountDeriveIndex,
  });

  @override
  String toString() {
    final _data = <String, dynamic>{};
    _data['chainKey'] = chainKey;
    _data['accountPosition'] = accountPosition;
    _data['accountAddress'] = accountAddress;
    _data['accountPrivateKey'] = accountPrivateKey;
    _data['accountPublicKey'] = accountPublicKey;
    _data['accountExtendedPrivateKey'] = accountExtendedPrivateKey;
    _data['accountExtendedPublicKey'] = accountExtendedPublicKey;
    _data['extendedPath'] = extendedPath;
    _data['accountPath'] = accountPath;
    _data['wipPrivateKey'] = wipPrivateKey;
    _data['secretKey'] = secretKey;
    _data['seed'] = seed;
    _data['accountFormat'] = accountFormat;
    _data['accountDeriveIndex'] = accountDeriveIndex;
    return _data.toString();
  }

  void extendKey(int coinType) {
    var blockchain = TWCoinType.TWCoinTypeBlockchain(coinType);

    /// 某些大链类型的特殊处理
    switch (blockchain) {
      case 55: // for bitcoincash block chain.
      case TWBlockchain.TWBlockchainBitcoin:
        wipPrivateKey = WalletMethodUtils.encodeWIFPrivateKey(accountPrivateKey, coinType: coinType);
        break;
      case TWBlockchain.TWBlockchainSolana:
        secretKey = WalletMethodUtils.concatKeyPairToB58SecretKey(accountPrivateKey, accountPublicKey);
        break;
    }
  }
}
