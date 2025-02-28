import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_trust_wallet_core_platform_interface.dart';

/// An implementation of [FlutterTrustWalletCorePlatform] that uses method channels.
class MethodChannelFlutterTrustWalletCore extends FlutterTrustWalletCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_trust_wallet_core');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
