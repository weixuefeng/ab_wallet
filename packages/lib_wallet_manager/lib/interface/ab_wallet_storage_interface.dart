import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

abstract class ABWalletStorageInterface {
  Future<void> saveWalletList({required List<ABWalletInfo> walletInfo});

  Future<List<ABWalletInfo>> getAllWalletList();

  Future<ABWalletInfo> getWalletByWalletId({required int walletId});

  Future<bool> updateWalletName({required int walletId, required String newName});

  Future<bool> updateWalletIndex({required int walletId, required int newIndex});

  Future<bool> updateWalletPassword({required int walletId, required String oldPassword, required String newPassword});
}
