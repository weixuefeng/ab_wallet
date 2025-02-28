import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core_platform_interface.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTrustWalletCorePlatform
    with MockPlatformInterfaceMixin
    implements FlutterTrustWalletCorePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterTrustWalletCorePlatform initialPlatform =
      FlutterTrustWalletCorePlatform.instance;

  test('$MethodChannelFlutterTrustWalletCore is the default instance', () {
    expect(
      initialPlatform,
      isInstanceOf<MethodChannelFlutterTrustWalletCore>(),
    );
  });

  test('getPlatformVersion', () async {
    FlutterTrustWalletCore flutterTrustWalletCorePlugin =
        FlutterTrustWalletCore();
    MockFlutterTrustWalletCorePlatform fakePlatform =
        MockFlutterTrustWalletCorePlatform();
    FlutterTrustWalletCorePlatform.instance = fakePlatform;

    // expect(await flutterTrustWalletCorePlugin.getPlatformVersion(), '42');
  });
}
