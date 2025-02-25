import 'package:lib_base/lib_base.dart';
import 'package:lib_storage/ab_cache_utils.dart';
import 'package:mmkv/mmkv.dart';

class ABStorageSecureKV {
  ABStorageSecureKV._internal();

  static const _uuid = "ab_secure_kv";

  static String _cryptKey = "";

  static MMKV? _mmkv;

  static setup(String cryptKey) {
    _cryptKey = cryptKey;
  }

  static MMKV? _getMMKV() {
    _mmkv ??= MMKV(_uuid, cryptKey: _cryptKey);
    return _mmkv;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveString(
    String key,
    String value, {
    int? expireDurationInSecond,
  }) {
    ABLogger.i(
      "saveString key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond",
    );
    _getMMKV()?.encodeString(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  static String? queryString(String key, {String? defaultValue}) {
    return _getMMKV()?.decodeString(key) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveInt32(String key, int value, {int? expireDurationInSecond}) {
    ABLogger.i(
      "saveInt32 key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond",
    );
    _getMMKV()?.encodeInt32(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  static int queryInt32(String key, {int defaultValue = 0}) {
    ABLogger.i(
      "queryInt32 key: ${ABCacheUtils.checkKey(key)}, defaultValue: $defaultValue",
    );
    return _getMMKV()?.decodeInt32(key, defaultValue: defaultValue) ??
        defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveInt(String key, int value, {int? expireDurationInSecond}) {
    ABLogger.i(
      "saveInt key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond",
    );
    _getMMKV()?.encodeInt(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  static int queryInt(String key, {int defaultValue = 0}) {
    ABLogger.i(
      "queryInt key: ${ABCacheUtils.checkKey(key)}, defaultValue: $defaultValue",
    );
    return _getMMKV()?.decodeInt(key, defaultValue: defaultValue) ??
        defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveDouble(
    String key,
    double value, {
    int? expireDurationInSecond,
  }) {
    ABLogger.i(
      "saveDouble key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond",
    );
    _getMMKV()?.encodeDouble(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  static double queryDouble(String key, {double defaultValue = 0}) {
    ABLogger.i(
      "queryDouble key: ${ABCacheUtils.checkKey(key)}, defaultValue: $defaultValue",
    );
    return _getMMKV()?.decodeDouble(key, defaultValue: defaultValue) ??
        defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveBool(String key, bool value, {int? expireDurationInSecond}) {
    ABLogger.i(
      "saveBool key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond",
    );
    _getMMKV()?.encodeBool(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  static bool queryBool(String key, {bool defaultValue = false}) {
    ABLogger.i(
      "queryBool key: ${ABCacheUtils.checkKey(key)}, defaultValue: $defaultValue",
    );
    return _getMMKV()?.decodeBool(key, defaultValue: defaultValue) ??
        defaultValue;
  }

  /// 是否包含某个 Key
  static bool containsKey(String key) {
    return _getMMKV()?.containsKey(key) ?? false;
  }

  /// 删除某个缓存
  static void remove(String key) {
    _getMMKV()?.removeValue(key);
  }

  /// 删除多个缓存
  static void removeValues(List<String> keys) {
    _getMMKV()?.removeValues(keys);
  }

  // /// 清空缓存文件
  // static void clearAll() {
  //   _mmkv?.clearAll();
  // }

  /// 清空缓存内存
  static void clearMemoryCache() {
    _getMMKV()?.clearMemoryCache();
  }
}
