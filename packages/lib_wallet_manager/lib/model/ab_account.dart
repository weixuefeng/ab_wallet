import 'package:lib_wallet_manager/model/ab_account_detail.dart';

typedef ChainId = int;

class ABAccount {
  /// account index;
  late int index;

  /// account name;
  late String accountName;

  /// 账户数据详情列表
  late Map<ChainId, ABAccountDetail> accountDetailsMap;

  /// wallet -> account1
  ///        -> account2  -> {0, btc},{1, eth}
  ///
  ///
  ABAccount({required this.index, required this.accountName, required this.accountDetailsMap});

  toJson() {
    return {
      'index': index,
      'accountName': accountName,
      'accountDetailsMap': accountDetailsMap.map((key, value) => MapEntry(key.toString(), value.toJson())),
    };
  }

  factory ABAccount.fromJson(Map<String, dynamic> json) {
    return ABAccount(
      index: json['index'],
      accountName: json['accountName'],
      accountDetailsMap: (json['accountDetailsMap'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(int.parse(key), ABAccountDetail.fromJson(value));
      }),
    );
  }
}
