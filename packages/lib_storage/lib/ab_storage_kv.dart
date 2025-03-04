import 'package:lib_base/lib_base.dart';
import 'package:lib_storage/ab_cache.dart';
import 'package:lib_storage/ab_cache_utils.dart';
import 'package:mmkv/mmkv.dart';

class ABStorageKV {
  static MMKV? _mmkv;

  ABStorageKV._();

  static MMKV? _getDefaultMMKV() {
    _mmkv ??= MMKV.defaultMMKV();
    // 打开自动过期，但全部不设置过期时间
    _mmkv?.enableAutoKeyExpire(ABCache.ExpireNever);
    return _mmkv;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveString(String key, String value, {int? expireDurationInSecond}) {
    ABLogger.i("saveString key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond");
    _getDefaultMMKV()?.encodeString(key, value, ABCacheUtils.checkExpireTime(expireDurationInSecond));
  }

  static String? queryString(String key, {String? defaultValue}) {
    ABLogger.i("queryString key: ${ABCacheUtils.checkKey(key)}");
    return _getDefaultMMKV()?.decodeString(key) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveInt32(String key, int value, {int? expireDurationInSecond}) {
    ABLogger.i("saveInt32 key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond");
    _getDefaultMMKV()?.encodeInt32(key, value, ABCacheUtils.checkExpireTime(expireDurationInSecond));
  }

  static int queryInt32(String key, {int defaultValue = 0}) {
    ABLogger.i("queryInt32 key: ${ABCacheUtils.checkKey(key)}");
    return _getDefaultMMKV()?.decodeInt32(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveInt(String key, int value, {int? expireDurationInSecond}) {
    ABLogger.i("saveInt key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond");
    _getDefaultMMKV()?.encodeInt(key, value, ABCacheUtils.checkExpireTime(expireDurationInSecond));
  }

  static int queryInt(String key, {int defaultValue = 0}) {
    return _getDefaultMMKV()?.decodeInt(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveDouble(String key, double value, {int? expireDurationInSecond}) {
    ABLogger.i("saveDouble key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond");
    _getDefaultMMKV()?.encodeDouble(key, value, ABCacheUtils.checkExpireTime(expireDurationInSecond));
  }

  static double queryDouble(String key, {double defaultValue = 0}) {
    ABLogger.i("queryDouble key: ${ABCacheUtils.checkKey(key)}");
    return _getDefaultMMKV()?.decodeDouble(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  static void saveBool(String key, bool value, {int? expireDurationInSecond}) {
    ABLogger.i("saveBool key: ${ABCacheUtils.checkKey(key)}, expireDurationInSecond: $expireDurationInSecond");
    _getDefaultMMKV()?.encodeBool(key, value, ABCacheUtils.checkExpireTime(expireDurationInSecond));
  }

  static bool queryBool(String key, {bool defaultValue = false}) {
    ABLogger.i("queryBool key: ${ABCacheUtils.checkKey(key)}");
    return _getDefaultMMKV()?.decodeBool(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// 是否包含某个 Key
  static bool containsKey(String key) {
    return _getDefaultMMKV()?.containsKey(key) ?? false;
  }

  /// 删除某个缓存
  static void remove(String key) {
    _getDefaultMMKV()?.removeValue(key);
  }

  /// 删除多个缓存
  static void removeValues(List<String> keys) {
    _getDefaultMMKV()?.removeValues(keys);
  }

  // /// 清空缓存文件
  // static void clearAll() {
  //   _mmkv?.clearAll();
  // }

  /// 清空缓存内存
  static void clearMemoryCache() {
    _getDefaultMMKV()?.clearMemoryCache();
  }
}
