import 'package:lib_base/lib_base.dart';

/// Author: Shper
/// Created: 2024/11/27
class ABCacheUtils {
  static const int ExpireNever = 0;
  static const int ExpireInMinute = 60;
  static const int ExpireInHour = 60 * 60;
  static const int ExpireInDay = 24 * 60 * 60;
  static const int ExpireInWeek = 7 * 24 * 60 * 60;
  static const int ExpireInMonth = 30 * 24 * 60 * 60;
  static const int ExpireInYear = 365 * 30 * 24 * 60 * 60;

  ABCacheUtils._internal();

  /// 检查过期时间是否超过一年返回一年 或 小于0 返回 0
  static int? checkExpireTime(int? expireDurationInSecond) {
    if (expireDurationInSecond == null) {
      return null;
    }

    if (expireDurationInSecond < 0) {
      return 0;
    } else if (expireDurationInSecond > ExpireInYear) {
      return ExpireInYear;
    } else {
      return expireDurationInSecond;
    }
  }

  /// 检查Key 是否为空
  static String checkKey(String? key) {
    if (key == null || key.isEmpty) {
      return "KeyNullOrEmpty";
    }
    if (key.length > 64) {
      ABLogger.i("MMKV KeyLenABhOver64: $key");
    }
    return key;
  }
}
