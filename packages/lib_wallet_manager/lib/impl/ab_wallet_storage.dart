import 'dart:convert';

import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_wallet_manager/interface/ab_wallet_storage_interface.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

class ABWalletStorage extends ABWalletStorageInterface {
  static const String tag = "ab_wallet_storage";
  static const String walletCounterKey = '${tag}_wallet_id_counter';
  static const String accountCounterKey = '${tag}_account_counter';
  static const String walletListKey = '${tag}_wallet_list';

  ABWalletStorage._internal();

  static final ABWalletStorage instance = ABWalletStorage._internal();

  factory ABWalletStorage() {
    return instance;
  }

  Future<int> getWalletNextId() async {
    int currentId = ABStorageKV.queryInt(walletCounterKey, defaultValue: -1);
    int nextId = currentId + 1;
    ABStorageKV.saveInt(walletCounterKey, nextId);
    return nextId;
  }

  Future<int> getAccountNextId({required int walletId}) async {
    var key = "${accountCounterKey}_$walletId";
    int currentId = ABStorageKV.queryInt(key, defaultValue: -1);
    int nextId = currentId + 1;
    ABStorageKV.saveInt(key, nextId);
    return nextId;
  }

  @override
  Future<ABWalletInfo> getWalletByWalletId({required int walletId}) {
    // TODO: implement getWalletByWalletId
    throw UnimplementedError();
  }

  @override
  Future<void> saveWalletList({required List<ABWalletInfo> walletInfo}) {
    var key = walletListKey;
    var value = walletInfo.map((e) => e.toJson()).toList();
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
      var wallets = await getAllWalletList();
      wallets.removeWhere((item) => item.flag == walletInfo.flag);
      await saveWalletList(walletInfo: wallets);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateWalletInfo({required ABWalletInfo walletInfo}) async {
    var wallets = await getAllWalletList();
    var index = wallets.indexWhere((element) => element.flag == walletInfo.flag);
    if (index == -1) {
      throw "not found wallet info for ${walletInfo.walletName}";
    }
    wallets[index] = walletInfo;
    await saveWalletList(walletInfo: wallets);
    return true;
  }
}
