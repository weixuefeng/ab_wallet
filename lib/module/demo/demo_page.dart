import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/impl/ab_chain_manager_impl.dart';
import 'package:lib_chain_manager/mock/mock_ab_chain_manager_impl.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_manager.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';
import 'package:lib_wallet_manager/model/ab_wallet_type.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';

class B {
  late String title;
  late ABWalletType type2;
  toJson() {
    return {'title': title, 'type': type2.walletType};
  }
}

class A {
  late String name;
  late ABWalletType type;
  late B b;

  // @override
  // String toString() {
  //   return jsonEncode(toJson());
  // }

  toJson() {
    return {'name': name, 'type': type.walletType, 'b': b.toJson()};
  }
}

class DemoPage extends HookConsumerWidget {
  const DemoPage({super.key});

  void createWallet() async {
    FlutterTrustWalletCore.init();
    await ABStorageInitializer.setup();
    var chainInfos = await MockAbChainManagerImpl.instance.getAllChainInfos();
    var walletName = "钱包1";
    var password = "123456";
    var mnemonic = "cargo vast funny blast cliff bullet galaxy spring prosper poet control magnet";
    var wallet = await AbWalletManager.instance.createWalletsByMnemonicAndCoinTypes(
      walletName: walletName,
      password: password,
      mnemonic: mnemonic,
      chainInfos: chainInfos,
    );
    var info = await AbWalletManager.instance.getAllWalletInfos();
    ABLogger.d(info.toPrettyString());
  }

  void getAllWallet() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text("Demo Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: () => {createWallet()}, child: Text("create wallet")),
            ElevatedButton(onPressed: () => {getAllWallet()}, child: Text("get All wallet")),
          ],
        ),
      ),
    );
  }
}
