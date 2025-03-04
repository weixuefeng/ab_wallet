import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_wallet_type.dart';

class ABWalletInfo {
  /// wallet id
  late int walletId;

  /// wallet index
  late int walletIndex;

  /// wallet name
  late String walletName;

  /// wallet type
  late ABWalletType walletType;

  /// wallet accounts
  late List<ABAccount> walletAccounts;

  // encrypt string
  late String encryptStr;

  // wallet flag
  late String flag;

  // construct
  ABWalletInfo({
    required this.walletId,
    required this.walletIndex,
    required this.walletName,
    required this.walletType,
    required this.walletAccounts,
    required this.encryptStr,
    required this.flag,
  });

  @override
  toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'walletIndex': walletIndex,
      'walletName': walletName,
      'walletType': walletType.typeIndex,
      'walletAccounts': walletAccounts.map((e) => e.toJson()).toList(),
      'encryptStr': encryptStr,
      'flag': flag,
    };
  }

  factory ABWalletInfo.fromJson(Map<String, dynamic> json) {
    return ABWalletInfo(
      walletId: json['walletId'],
      walletIndex: json['walletIndex'],
      walletName: json['walletName'],
      walletType: ABWalletType.fromIndex(json['walletType']),
      walletAccounts: (json['walletAccounts'] as List).map((e) => ABAccount.fromJson(e)).toList(),
      encryptStr: json['encryptStr'],
      flag: json['flag'] ?? '',
    );
  }
}
