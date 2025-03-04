import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_wallet_manager/model/ab_protocol_account.dart';

class ABAccountDetail {
  /// 公钥信息
  late String defaultPublicKey;

  /// 账户地址
  late String defaultAddress;

  /// 衍生路径
  late String derivationPath;

  /// 加密密钥
  late String encryptedKey;

  /// 账户所属的链信息
  late ABChainInfo chainInfo;

  /// 额外的协议地址，eg: btc 的 taproot，legacy，segwit...
  List<ABProtocolAccount>? protocolAccounts;

  /// 是否有 protocol account
  get haveProtocolAccount => protocolAccounts?.isEmpty;

  ABAccountDetail({
    required this.defaultPublicKey,
    required this.defaultAddress,
    required this.derivationPath,
    required this.chainInfo,
    required this.encryptedKey,
    this.protocolAccounts,
  });

  toJson() {
    return {
      'defaultPublicKey': defaultPublicKey,
      'defaultAddress': defaultAddress,
      'derivationPath': derivationPath,
      'encryptKey': encryptedKey,
      'chainInfo': chainInfo.toJson(),
      'protocolAccounts': protocolAccounts?.map((e) => e.toJson()).toList(),
    };
  }

  factory ABAccountDetail.fromJson(Map<String, dynamic> json) {
    return ABAccountDetail(
      defaultPublicKey: json['defaultPublicKey'],
      defaultAddress: json['defaultAddress'],
      derivationPath: json['derivationPath'],
      encryptedKey: json['encryptKey'],
      chainInfo: ABChainInfo.fromJson(json['chainInfo']),
      protocolAccounts:
          json['protocolAccounts'] == null
              ? null
              : (json['protocolAccounts'] as List).map((e) => ABProtocolAccount.fromJson(e)).toList(),
    );
  }
}
