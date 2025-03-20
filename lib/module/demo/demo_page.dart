import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ab_wallet/module/demo/demo_chain_page.dart';
import 'package:ab_wallet/module/demo/demo_component_page.dart';
import 'package:ab_wallet/module/demo/demo_setting_page.dart';
import 'package:ab_wallet/module/demo/demo_wallet_page.dart';
import 'package:ab_wallet/module/demo/demo_network_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DemoPage extends HookConsumerWidget {
  const DemoPage({super.key});

  void _createMnemonicWallet(BuildContext context) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DemoWalletPage();
        },
      ),
    );
  }

  void _toChainDemoPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DemoChainPage();
        },
      ),
    );
  }

  void _toSettingDemoPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DemoSettingPage();
        },
      ),
    );
  }

  void _goComponent(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DemoComponentPage();
        },
      ),
    );
  }

  void _goNetwork(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DemoNetworkPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Demo Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => {_createMnemonicWallet(context)},
              child: Text("钱包生成"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {(_toChainDemoPage(context))},
              child: Text("RPC方法测试"),
            ),
            ElevatedButton(
              onPressed: () => {(_toSettingDemoPage(context))},
              child: Text("Setting测试"),
            ),
            ElevatedButton(
              onPressed: () => {_goComponent(context)},
              child: Text("组件设置"),
            ),
            ElevatedButton(
              onPressed: () => {_goNetwork(context)},
              child: Text("网络管理设置"),
            ),
          ],
        ),
      ),
    );
  }
}
