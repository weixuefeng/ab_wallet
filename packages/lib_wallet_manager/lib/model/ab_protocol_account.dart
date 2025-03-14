import 'package:lib_wallet_manager/model/ab_account_protocol_type.dart';

class ABProtocolAccount {
  /// 公钥信息
  late String publicKeyHex;

  /// 账户地址
  late String address;

  /// 衍生路径
  late String derivationPath;

  /// 协议类型
  late ABAccountProtocolType protocolType;

  ABProtocolAccount({
    required this.publicKeyHex,
    required this.address,
    required this.derivationPath,
    required this.protocolType,
  });

  toJson() {
    return {
      'publicKeyHex': publicKeyHex,
      'address': address,
      'derivationPath': derivationPath,
      'protocolType': protocolType.protocolIndex,
    };
  }

  factory ABProtocolAccount.fromJson(Map<String, dynamic> json) {
    return ABProtocolAccount(
      publicKeyHex: json['publicKeyHex'],
      address: json['address'],
      derivationPath: json['derivationPath'],
      protocolType: ABAccountProtocolType.fromIndex(json['protocolType']),
    );
  }
}
