import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:ab_wallet/module/demo/demo_chain_page.dart';
import 'package:ab_wallet/module/demo/demo_component_page.dart';
import 'package:ab_wallet/module/demo/demo_setting_page.dart';
import 'package:ab_wallet/utils/time_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/lib_chain_manager.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_manager.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';

class DemoWalletPage extends HookConsumerWidget {
  const DemoWalletPage({super.key});

  void createMnemonicWallet() async {
    FlutterTrustWalletCore.init();
    await ABStorageInitializer.setup();
    var chainInfos = await MockAbChainManagerImpl.instance.getAllChainInfos();
    var walletName = "钱包2";
    var password = "123456";
    var start = nowTimeStamp();
    var mnemonic = "office final light crunch math photo broccoli poet congress view head square";
    // HDWallet().mnemonic();
    ABLogger.d("mnemonic: $mnemonic");
    var wallet = await ABWalletManager.instance.createWalletsByMnemonicAndCoinTypes(
      walletName: walletName,
      password: password,
      mnemonic: mnemonic,
      chainInfos: chainInfos,
    );
    ABLogger.d(wallet.toJson());
    var end = nowTimeStamp();
    ABLogger.d("time: ${end - start}");
  }

  void createPrivateKeyWallet() async {
    FlutterTrustWalletCore.init();
    await ABStorageInitializer.setup();
    var chainInfos = await MockAbChainManagerImpl.instance.getAllChainInfos();
    var walletName = "钱包4";
    var password = "123456";
    var mnemonic = HDWallet().getKeyForCoin(60).data().toHex();
    var wallet = await ABWalletManager.instance.createWalletByPrivateKeyAndCoinType(
      walletName: walletName,
      password: password,
      privateKey: mnemonic,
      chainInfo: chainInfos[0],
    );
    ABLogger.d(wallet.toJson());
  }

  void deleteWallet() async {
    FlutterTrustWalletCore.init();
    await ABStorageInitializer.setup();
    var info = await ABWalletManager.instance.getAllWalletInfos();
    ABLogger.d("before wallet length: ${info.length}");
    if (info.isEmpty) {
      ABLogger.d("wallet is empty");
      return;
    }
    var deleted = await ABWalletManager.instance.deleteWallet(walletInfo: info[0]);
    info = await ABWalletManager.instance.getAllWalletInfos();
    ABLogger.d("after wallet length: ${info.length}  deleted: ${deleted}");
  }

  void addAccountForWallet() async {
    FlutterTrustWalletCore.init();
    await ABStorageInitializer.setup();

    var wallet = await ABWalletManager.instance.getAllWalletInfos();
    var account = await ABWalletManager.instance.addAcountForWallet(info: wallet[0], password: "123456");
    ABLogger.d(account.toJson());
  }

  void getAllWallet() async {
    var info = await ABWalletManager.instance.getAllWalletInfos();
    ABLogger.d(info.map((wallet) => wallet.toJson()).toList());
  }

  void decryptWallet() async {
    // 可以将当前钱包，当前账户设置到缓存里面，直接无需参数的进行解密
    var wallet = await ABWalletManager.instance.getAllWalletInfos();
    var privateKey = await ABWalletManager.instance.decryptWallet(
      walletInfo: wallet[0],
      password: "123456",
      account: wallet[0].walletAccounts[0],
      chainId: 1,
    );
    var secret = wallet[0].encryptStr;
    ABLogger.d("secret: $secret");
    ABLogger.d(WalletMethodUtils.decryptAES(secret, "123456"));
    ABLogger.d(privateKey);
  }

  void exportKeystore() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text("Demo Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: () => {createMnemonicWallet()}, child: Text("创建助记词钱包")),
            ElevatedButton(onPressed: () => {createPrivateKeyWallet()}, child: Text("创建私钥钱包")),
            ElevatedButton(onPressed: () => {getAllWallet()}, child: Text("获取全部钱包")),
            ElevatedButton(onPressed: () => {deleteWallet()}, child: Text("删除第一个钱包")),
            ElevatedButton(onPressed: () => {addAccountForWallet()}, child: Text("给助记词钱包添加账户")),
            ElevatedButton(onPressed: () => {decryptWallet()}, child: Text("解密钱包")),
            ElevatedButton(onPressed: () => {(exportKeystore())}, child: Text("导出 keystore")),
          ],
        ),
      ),
    );
  }
}
