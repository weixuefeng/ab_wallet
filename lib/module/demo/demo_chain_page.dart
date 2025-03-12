import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/mock/mock_ab_chain_manager_impl.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_manager.dart';
import 'package:lib_web3_core/impl/chain_method_impl.dart';
import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';
import 'package:lib_web3_interaction/chains/rpc/rpc_address_provider.dart';
import 'package:lib_web3_interaction/mock/mock_lib_ab_web3_core_module_impl.dart';

class DemoChainPage extends HookConsumerWidget {
  const DemoChainPage({super.key});

  static const String TAG = 'DemoChainPage';

  static const int ethNetworkId = 1;
  static const int ethTestNetworkId = 7;
  static const int polNetworkId = 2;

  ///获取主代币余额地址
  static const String evmAddress = '0x56A29fb2F1f6D81FD1cAb5564eC4C41410c1AbEa';

  ///初始化
  void initCore(){
    ///初始化trustWalletCore
    FlutterTrustWalletCore.init();

    ///初始化lib库：ABWeb3CoreModule
    ABWeb3CoreModule.init(MockLibABWeb3CoreModuleImpl.instance);

    ///初始化节点管理器
    var providerImpl = ABWeb3ChainRpcAddressProviderImpl();
    ABWeb3ChainRpcAddressProvider.init(providerImpl);

    ///在节点管理器初始化时拉取 lib:链管理库 中的网络信息（这里应该前置请求）
    providerImpl.ensureInitialized();
  }

  void getCoinBalance() async {
    initCore();


    MockLibABWeb3CoreModuleImpl.instance.getWeb3Network(
      networkId: ethTestNetworkId,
    );

    ABWeb3Chain abWeb3Chain = await ABWeb3ChainFactory.create(ethTestNetworkId);

    ABLogger.e('$TAG:当前chainId--->${abWeb3Chain.networkId}');

    var chainInfos = await MockAbChainManagerImpl.instance.getCacheAllChainInfos();

    var balance = await abWeb3Chain.balance(address: evmAddress);

    ABLogger.e('$TAG:当前余额--->$balance');
  }

  void getContractTokenBalance() async {
    initCore();
    MockLibABWeb3CoreModuleImpl.instance.getWeb3Network(
      networkId: ethNetworkId,
    );
    ABWeb3Chain abWeb3Chain = await ABWeb3ChainFactory.create(ethNetworkId);
    var balance = await abWeb3Chain.tokenBalance(address: evmAddress,tokenAddress:'0xdAC17F958D2ee523a2206206994597C13D831ec7');
    ABLogger.e('$TAG:当前合约代币余额--->$balance');
  }

  void deleteWallet() async {}

  void addAccountForWallet() async {}

  void getAllWallet() async {
    var info = await ABWalletManager.instance.getAllWalletInfos();
    ABLogger.d(info.map((wallet) => wallet.toJson()).toList());
  }

  void decryptWallet() async {

  }

  void exportKeystore() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("RPC方法测试 Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => {getCoinBalance()},
              child: Text("获取主代币余额"),
            ),
            ElevatedButton(
              onPressed: () => {getContractTokenBalance()},
              child: Text("获取20代币余额"),
            ),
            ElevatedButton(
              onPressed: () => {addAccountForWallet()},
              child: Text("预估gas费"),
            ),
            ElevatedButton(
              onPressed: () => {getAllWallet()},
              child: Text("构建主代币交易"),
            ),
            ElevatedButton(
              onPressed: () => {deleteWallet()},
              child: Text("构建合约代币交易"),
            ),
            ElevatedButton(
              onPressed: () => {(exportKeystore())},
              child: Text("构建EIP4844交易"),
            ),
            ElevatedButton(
              onPressed: () => {decryptWallet()},
              child: Text("签名交易"),
            ),
            ElevatedButton(
              onPressed: () => {(exportKeystore())},
              child: Text("发送交易"),
            ),
          ],
        ),
      ),
    );
  }
}
