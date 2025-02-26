import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_wallet_manager/model/ab_protocol_account.dart';

class ABAccountDetail {
  /// 公钥信息
  late String defaultPublicKey;

  /// 账户地址
  late String defaultAddress;

  /// 衍生路径
  late String derivationPath;

  /// 账户所属的链信息
  late ABChainInfo chainInfo;

  /// 额外的协议地址，eg: btc 的 taproot，legacy，segwit...
  List<ABProtocolAccount>? protocolAccounts;

  /// 是否有 protocol account
  get haveProtocolAccount => protocolAccounts?.isEmpty;
}
