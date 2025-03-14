import 'package:lib_storage/ab_storage_kv.dart';

class Counter {
  static const String tag = "ab_wallet_storage_counter";
  static const String walletCounterKey = '${tag}_wallet_id_counter';
  static const String accountCounterKey = '${tag}_account_id_counter';
  static const String accountIndexCounterKey = '${tag}_account_index_counter';

  static Future<int> getWalletNextId() async {
    int currentId = ABStorageKV.queryInt(walletCounterKey, defaultValue: -1);
    int nextId = currentId + 1;
    ABStorageKV.saveInt(walletCounterKey, nextId);
    return nextId;
  }

  static Future<int> getAccountNextId() async {
    int currentId = ABStorageKV.queryInt(accountCounterKey, defaultValue: -1);
    int nextId = currentId + 1;
    ABStorageKV.saveInt(accountCounterKey, nextId);
    return nextId;
  }

  static Future<int> getAccountNextIndex({required int walletId}) async {
    var key = "${accountIndexCounterKey}_$walletId";
    int currentId = ABStorageKV.queryInt(key, defaultValue: -1);
    int nextId = currentId + 1;
    ABStorageKV.saveInt(key, nextId);
    return nextId;
  }
}
