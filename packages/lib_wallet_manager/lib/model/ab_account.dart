import 'package:lib_wallet_manager/model/ab_account_detail.dart';

typedef ChainId = int;

class ABAccount {
  late int id;

  /// account index;
  late int index;

  /// wallet id;
  late int walletId;

  /// account name;
  late String accountName;

  /// 账户数据详情列表
  late Map<ChainId, ABAccountDetail> accountDetailsMap;

  ABAccount({
    required this.id,
    required this.walletId,
    required this.index,
    required this.accountName,
    required this.accountDetailsMap,
  });

  toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'index': index,
      'accountName': accountName,
      'accountDetailsMap': accountDetailsMap.map((key, value) => MapEntry(key.toString(), value.toJson())),
    };
  }

  factory ABAccount.fromJson(Map<String, dynamic> json) {
    return ABAccount(
      id: json['id'],
      walletId: json['walletId'],
      index: json['index'],
      accountName: json['accountName'],
      accountDetailsMap: (json['accountDetailsMap'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(int.parse(key), ABAccountDetail.fromJson(value));
      }),
    );
  }
}
