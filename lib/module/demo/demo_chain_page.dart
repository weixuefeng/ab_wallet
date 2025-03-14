import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/mock/mock_ab_chain_manager_impl.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_manager.dart';
import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_account_detail.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';
import 'package:lib_web3_chain_interact/base/i_ab_web3_core_module.dart';
import 'package:lib_web3_chain_interact/chains/impl/networks/evm/evm.dart';
import 'package:lib_web3_chain_interact/chains/interface/networks/evm.dart';
import 'package:lib_web3_chain_interact/lib_web3_chain_interact.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';

class DemoChainPage extends HookConsumerWidget {
  const DemoChainPage({super.key});

  static const String TAG = 'DemoChainPage';

  static const int ethNetworkId = 1;
  static const int ethTestNetworkId = 7;
  static const int polNetworkId = 2;

  ///获取主代币余额地址
  static const String evmAddress = '0x56A29fb2F1f6D81FD1cAb5564eC4C41410c1AbEa';

  ///初始化
  void initCore() {
    ///初始化trustWalletCore
    FlutterTrustWalletCore.init();

    ///初始化lib库：ABWeb3CoreModule
    ABWeb3CoreModule.init(ABWeb3CoreModuleImpl());
  }

  void getCoinBalance() async {
    initCore();

    var chainInfos = MockAbChainManagerImpl.instance.getCacheAllChainInfos();

    ABWeb3EVMNetworkImpl abWeb3Chain = ABWeb3CoreModule.instance.getWeb3Network(chainInfo: chainInfos.first);

    ABLogger.e('$TAG:当前chainId--->${abWeb3Chain.name}');

    var balance = await abWeb3Chain.getBalance(address: evmAddress);

    ABLogger.e('$TAG:当前余额--->$balance');
  }

  void getContractTokenBalance() async {
    initCore();
    var chainInfos = MockAbChainManagerImpl.instance.getCacheAllChainInfos();
    ABWeb3EVMNetworkImpl abWeb3Chain = await ABWeb3CoreModule.instance.getWeb3Network(chainInfo: chainInfos.first);
    var balance = await abWeb3Chain.getErc20TokenBalance(
      address: evmAddress,
      tokenAddress: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
    );
    ABLogger.e('$TAG:当前合约代币余额--->$balance');
  }

  void deleteWallet() async {}

  void addAccountForWallet() async {}

  void transferETHTest() async {
    initCore();
    List<ABWalletInfo> walletList = await ABWalletManager.instance.getAllWalletInfos();
    ABWalletInfo wallet = walletList.first;
    ABAccount account = wallet.walletAccounts.first;
    var chainInfo = MockAbChainManagerImpl.instance.ab;
    ABAccountDetail accountDetail = account.accountDetailsMap[chainInfo.chainId]!;
    var to = "0xdAC17F958D2ee523a2206206994597C13D831ec7";
    ABWeb3EVMNetworkImpl abWeb3Chain = await ABWeb3CoreModule.instance.getWeb3Network(chainInfo: chainInfo);
    var balance = await abWeb3Chain.getBalance(address: accountDetail.defaultAddress);
    ABLogger.d("balance: $balance");
    ABWeb3EVMTransaction tx = await abWeb3Chain.buildTransferTx(
      from: accountDetail.defaultAddress,
      to: to,
      amount: BigInt.from(1),
    );
    ABLogger.d("tx: ${tx.toString()}");
    var gas = await abWeb3Chain.estimateGas(tx: tx);
    ABLogger.d("gas: $gas");
    var privateKey = await ABWalletManager.instance.decryptWallet(
      walletInfo: wallet,
      password: "123456",
      account: account,
      chainId: chainInfo.chainId,
    );
    ABLogger.d("privateKey: ${privateKey.toString()}");
    var signer = ABWeb3Signer.fromPrivateKey(privateKey);
    var txs = await abWeb3Chain.signTxs(txs: [tx], signer: signer);
    ABLogger.d(txs[0].signedRaw);
    var res = await abWeb3Chain.sendTxs(txs: txs);
    ABLogger.d(res.first.hash);
  }

  void decryptWallet() async {}

  void exportKeystore() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text("RPC方法测试 Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: () => {getCoinBalance()}, child: Text("获取主代币余额")),
            ElevatedButton(onPressed: () => {getContractTokenBalance()}, child: Text("获取20代币余额")),
            ElevatedButton(onPressed: () => {addAccountForWallet()}, child: Text("预估gas费")),
            ElevatedButton(onPressed: () => {transferETHTest()}, child: Text("构建主代币交易")),
            ElevatedButton(onPressed: () => {deleteWallet()}, child: Text("构建合约代币交易")),
            ElevatedButton(onPressed: () => {(exportKeystore())}, child: Text("构建EIP4844交易")),
            ElevatedButton(onPressed: () => {decryptWallet()}, child: Text("签名交易")),
            ElevatedButton(onPressed: () => {(exportKeystore())}, child: Text("发送交易")),
          ],
        ),
      ),
    );
  }
}
