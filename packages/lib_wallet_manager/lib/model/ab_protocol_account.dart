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
}
