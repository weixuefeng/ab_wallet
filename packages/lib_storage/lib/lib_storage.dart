import 'dart:io';
import 'package:lib_base/lib_base.dart';
import 'package:lib_storage/ab_storage_secure_kv.dart';
import 'package:mmkv/mmkv.dart';
import 'package:path_provider/path_provider.dart';

class ABStorageInitializer {
  /// 初始化
  static Future<void> setup({String? securityKey}) async {
    await _initMMKV();
    await _initStorageKey(securityKey);
  }

  /// 初始化 MMKV
  static Future<void> _initMMKV() async {
    // 和原生侧路径保持一致，
    Directory directory;
    if (Platform.isAndroid) {
      directory = await getApplicationSupportDirectory();
    } else if (Platform.isIOS || Platform.isMacOS) {
      directory = await getApplicationCacheDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final rootDir = "${directory.path}/mmkv";
    ABLogger.i("MMKV flutter set rootDir: $rootDir");

    final initedRootDir = await MMKV.initialize(rootDir: rootDir);
    ABLogger.i("MMKV flutter initedRootDir: $initedRootDir");
    if (initedRootDir == null || initedRootDir.isEmpty) {
      throw StateError("MMKV initialization failed: rootDir is null or empty.");
    }
  }

  /// 获取存储加密 Key
  static Future<void> _initStorageKey(String? key) async {
    ABStorageSecureKV.setup(key ?? "");
  }
}
