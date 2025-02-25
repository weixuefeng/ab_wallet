import 'package:lib_base/lib_base.dart';
import 'package:lib_storage/ab_cache_utils.dart';
import 'package:mmkv/mmkv.dart';

class ABCache {
  static const int ExpireNever = ABCacheUtils.ExpireNever;
  static const int ExpireInMinute = ABCacheUtils.ExpireInMinute;
  static const int ExpireInHour = ABCacheUtils.ExpireInHour;
  static const int ExpireInDay = ABCacheUtils.ExpireInDay;
  static const int ExpireInWeek = ABCacheUtils.ExpireInWeek;
  static const int ExpireInMonth = ABCacheUtils.ExpireInMonth;
  static const int ExpireInYear = ABCacheUtils.ExpireInYear;

  MMKV? _mmkv;

  ABCache(String uuid, {String? cryptKey}) {
    if (uuid.isEmpty) {
      return;
    }

    if (!uuid.startsWith("ab_cache")) {
      uuid = "ab_cache_$uuid";
    }
    _mmkv = MMKV(uuid, cryptKey: cryptKey);
    // 打开自动过期，但全部不设置过期时间
    _mmkv?.enableAutoKeyExpire(ExpireNever);
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  void saveString(String key, String value, {int? expireDurationInSecond}) {
    _mmkv?.encodeString(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  String? queryString(String key, {String? defaultValue}) {
    return _mmkv?.decodeString(key) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  void saveInt32(String key, int value, {int? expireDurationInSecond}) {
    ABLogger.i(
      "saveInt32 by key: ${ABCacheUtils.checkKey(key)} expireDurationInSecond: $expireDurationInSecond",
    );
    _mmkv?.encodeInt32(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  int queryInt32(String key, {int defaultValue = 0}) {
    ABLogger.i("queryInt32 by key: ${ABCacheUtils.checkKey(key)}");
    return _mmkv?.decodeInt32(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  void saveInt(String key, int value, {int? expireDurationInSecond}) {
    ABLogger.i(
      "saveInt by key: ${ABCacheUtils.checkKey(key)} expireDurationInSecond: $expireDurationInSecond",
    );
    _mmkv?.encodeInt(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  int queryInt(String key, {int defaultValue = 0}) {
    return _mmkv?.decodeInt(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  void saveDouble(String key, double value, {int? expireDurationInSecond}) {
    ABLogger.i(
      "saveDouble by key: ${ABCacheUtils.checkKey(key)} expireDurationInSecond: $expireDurationInSecond",
    );
    _mmkv?.encodeDouble(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  double queryDouble(String key, {double defaultValue = 0}) {
    ABLogger.i("queryDouble by key: ${ABCacheUtils.checkKey(key)}");
    return _mmkv?.decodeDouble(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// [expireDurationInSecond] override the default duration setting from [enableAutoKeyExpire()]
  /// [expireDurationInSecond] 为 null 时，表示永不过期
  void saveBool(String key, bool value, {int? expireDurationInSecond}) {
    ABLogger.i(
      "saveBool by key: ${ABCacheUtils.checkKey(key)} expireDurationInSecond: $expireDurationInSecond",
    );
    _mmkv?.encodeBool(
      key,
      value,
      ABCacheUtils.checkExpireTime(expireDurationInSecond),
    );
  }

  bool queryBool(String key, {bool defaultValue = false}) {
    ABLogger.i("queryBool by key: ${ABCacheUtils.checkKey(key)}");
    return _mmkv?.decodeBool(key, defaultValue: defaultValue) ?? defaultValue;
  }

  /// 是否包含某个 Key
  bool containsKey(String key) {
    return _mmkv?.containsKey(key) ?? false;
  }

  /// 删除某个缓存
  void remove(String key) {
    _mmkv?.removeValue(key);
  }

  /// 删除多个缓存
  void removeValues(List<String> keys) {
    _mmkv?.removeValues(keys);
  }

  /// 清空缓存文件
  void clearAll() {
    _mmkv?.clearAll();
  }

  /// 清空缓存内存
  void clearMemoryCache() {
    _mmkv?.clearMemoryCache();
  }
}
