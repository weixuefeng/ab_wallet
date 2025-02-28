import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_trust_wallet_core_method_channel.dart';

abstract class FlutterTrustWalletCorePlatform extends PlatformInterface {
  /// Constructs a FlutterTrustWalletCorePlatform.
  FlutterTrustWalletCorePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTrustWalletCorePlatform _instance = MethodChannelFlutterTrustWalletCore();

  /// The default instance of [FlutterTrustWalletCorePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTrustWalletCore].
  static FlutterTrustWalletCorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTrustWalletCorePlatform] when
  /// they register themselves.
  static set instance(FlutterTrustWalletCorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
