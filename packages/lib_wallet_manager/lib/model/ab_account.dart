import 'package:lib_wallet_manager/model/ab_account_detail.dart';

typedef ChainId = int;

class ABAccount {
  /// account index;
  late int idnex;

  /// account name;
  late String accountName;

  /// account logo;
  late String accountLogo;

  /// 账户数据详情列表
  late Map<ChainId, ABAccountDetail> accountDetailsMap;

  /// wallet -> account1
  ///        -> account2  -> {0, btc},{1, eth}
  ///
}
