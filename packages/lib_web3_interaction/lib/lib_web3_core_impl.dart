
import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_web3_core/test/evm_test.dart';
import 'package:lib_web3_interaction/chains/evm/evm_impl.dart';
import 'package:lib_web3_interaction/chains/rpc/rpc_address_provider.dart';
import 'package:lib_web3_interaction/chains/solana/solana_impl.dart';

final class ABWeb3CoreModuleImpl extends ABWeb3CoreModule{
  ///调用这里进行初始化
  static void init(){
    ///调用抽象类的初始化
    ABWeb3CoreModule.init(ABWeb3CoreModuleImpl());

    ///初始化RPC的管理器
    ABWeb3ChainRpcAddressProvider.init(ABWeb3ChainRpcAddressProviderImpl());

  }

  @override
  Future<void> debug() async {
    // TODO: 测试方法可以放在lib_web3_interaction中
    EvmTest().test();
  }

  @override
  Future<int> decimals({required int networkId, String? tokenAddress}) {
    // TODO: implement decimals
    throw UnimplementedError();
  }

  @override
  getWeb3Network({required int networkId}) async {
    bool evmChain = await isEVMNetwork(networkId: networkId);
    if (evmChain) {
      return ABWeb3EVMChainImpl(networkId: networkId);
    }
    switch (networkId) {
      case 2:
        return ABWeb3SOLChainImpl(networkId: networkId);
      default:
        throw Exception('Unsupported network: $networkId');
    }
  }

  @override
  bool isEVMNetwork({required int networkId}) {
    // TODO: implement isEVMNetwork
    throw UnimplementedError();
  }

  @override
  void pushDebugPage() {
    // TODO: implement pushDebugPage
  }

  @override
  // TODO: implement rpcClient
  ABWeb3RPCClient get rpcClient => throw UnimplementedError();

}