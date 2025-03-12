import 'package:lib_wallet_manager/impl/ab_wallet_kv_storage.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_realm_storage.dart';
import 'package:lib_wallet_manager/interface/ab_wallet_storage_interface.dart';
import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

class ABWalletStorage extends ABWalletStorageInterface {
  bool useRealm = true;

  ABWalletStorage._internal();

  static final ABWalletStorage instance = ABWalletStorage._internal();

  factory ABWalletStorage() {
    return instance;
  }

  ABWalletStorageInterface getStorage() {
    if (useRealm) {
      return ABWalletRealmStorage.instance;
    } else {
      return ABWalletKVStorage.instance;
    }
  }

  @override
  Future<bool> addAcountForWallet({required ABWalletInfo walletInfo, required ABAccount accountInfo}) {
    return getStorage().addAcountForWallet(walletInfo: walletInfo, accountInfo: accountInfo);
  }

  @override
  Future<void> addWalletInfo({required ABWalletInfo walletInfo}) {
    return getStorage().addWalletInfo(walletInfo: walletInfo);
  }

  @override
  Future<bool> deleteWalletInfo({required ABWalletInfo walletInfo}) {
    return getStorage().deleteWalletInfo(walletInfo: walletInfo);
  }

  @override
  Future<List<ABWalletInfo>> getAllWalletList() {
    return getStorage().getAllWalletList();
  }

  @override
  Future<ABWalletInfo> getWalletByWalletId({required int walletId}) {
    return getStorage().getWalletByWalletId(walletId: walletId);
  }

  @override
  Future<bool> updateWalletIndex({required int walletId, required int newIndex}) {
    return getStorage().updateWalletIndex(walletId: walletId, newIndex: newIndex);
  }

  @override
  Future<bool> updateWalletName({required int walletId, required String newName}) {
    return getStorage().updateWalletName(walletId: walletId, newName: newName);
  }

  @override
  Future<bool> updateWalletPassword({required int walletId, required String oldPassword, required String newPassword}) {
    return getStorage().updateWalletPassword(walletId: walletId, oldPassword: oldPassword, newPassword: newPassword);
  }
}
