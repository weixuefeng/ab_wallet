import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

abstract class ABWalletStorageInterface {
  Future<void> addWalletInfo({required ABWalletInfo walletInfo});

  Future<List<ABWalletInfo>> getAllWalletList();

  Future<bool> deleteWalletInfo({required ABWalletInfo walletInfo});

  Future<ABWalletInfo> getWalletByWalletId({required int walletId});

  Future<bool> updateWalletName({required int walletId, required String newName});

  Future<bool> updateWalletIndex({required int walletId, required int newIndex});

  Future<bool> updateWalletPassword({required int walletId, required String oldPassword, required String newPassword});

  Future<bool> addAcountForWallet({required ABWalletInfo walletInfo, required ABAccount accountInfo});
}
