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
}
