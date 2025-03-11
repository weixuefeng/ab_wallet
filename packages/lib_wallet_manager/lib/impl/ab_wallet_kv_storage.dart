import 'dart:convert';

import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_wallet_manager/interface/ab_wallet_storage_interface.dart';
import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

class ABWalletKVStorage extends ABWalletStorageInterface {
  static const String tag = "ab_wallet_storage";
  static const String walletListKey = '${tag}_wallet_list';

  ABWalletKVStorage._internal();

  static final ABWalletKVStorage instance = ABWalletKVStorage._internal();

  factory ABWalletKVStorage() {
    return instance;
  }

  @override
  Future<ABWalletInfo> getWalletByWalletId({required int walletId}) {
    // TODO: implement getWalletByWalletId
    throw UnimplementedError();
  }

  @override
  Future<void> addWalletInfo({required ABWalletInfo walletInfo}) async {
    var key = walletListKey;
    var currentInfo = await getAllWalletList();

    /// TODO: 本地检查重复
    currentInfo.add(walletInfo);
    var value = currentInfo.map((e) => e.toJson()).toList();
    ABStorageKV.saveString(key, jsonEncode(value));
    return Future.value();
  }

  @override
  Future<List<ABWalletInfo>> getAllWalletList() {
    var key = walletListKey;
    var json = ABStorageKV.queryString(key);
    if (json == null) {
      return Future.value([]);
    }
    List<dynamic> list = jsonDecode(json) as List<dynamic>;
    List<ABWalletInfo> walletList = list.map((e) => ABWalletInfo.fromJson(e)).toList();
    return Future.value(walletList);
  }

  @override
  Future<bool> updateWalletIndex({required int walletId, required int newIndex}) {
    // TODO: implement updateWalletIndex
    throw UnimplementedError();
  }

  @override
  Future<bool> updateWalletName({required int walletId, required String newName}) {
    // TODO: implement updateWalletName
    throw UnimplementedError();
  }

  @override
  Future<bool> updateWalletPassword({required int walletId, required String oldPassword, required String newPassword}) {
    // TODO: implement updateWalletPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteWalletInfo({required ABWalletInfo walletInfo}) async {
    try {
      var key = walletListKey;
      var wallets = await getAllWalletList();
      wallets.removeWhere((item) => item.flag == walletInfo.flag);
      ABStorageKV.saveString(key, jsonEncode(wallets));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> addAcountForWallet({required ABWalletInfo walletInfo, required ABAccount accountInfo}) async {
    var key = walletListKey;
    var wallets = await getAllWalletList();
    var index = wallets.indexWhere((element) => element.flag == walletInfo.flag);
    if (index == -1) {
      throw "not found wallet info for ${walletInfo.walletName}";
    }
    walletInfo.walletAccounts.add(accountInfo);
    wallets[index] = walletInfo;
    ABStorageKV.saveString(key, jsonEncode(wallets));
    return true;
  }
}
