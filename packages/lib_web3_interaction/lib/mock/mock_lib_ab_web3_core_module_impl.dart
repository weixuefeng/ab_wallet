
import 'package:lib_base/lib_base.dart';
import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_chain_manager/mock/mock_ab_chain_manager_impl.dart';
import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_web3_interaction/chains/evm/evm_impl.dart';
import 'package:lib_web3_interaction/chains/solana/solana_impl.dart';

class MockLibABWeb3CoreModuleImpl extends ABWeb3CoreModule{

  MockLibABWeb3CoreModuleImpl._internal();

  static final  MockLibABWeb3CoreModuleImpl instance =  MockLibABWeb3CoreModuleImpl._internal();

  factory MockLibABWeb3CoreModuleImpl(){
    return instance;
  }

  @override
  Future<void> debug() {
    // TODO: implement debug
    throw UnimplementedError();
  }

  @override
  Future<int> decimals({required int networkId, String? tokenAddress}) {
    int decimal = 6;
    ABLogger.e('如何获取20代币的精度');
    return Future.value(decimal) ;
  }

  @override
  getWeb3Network({required int networkId})  {
   bool evmChain =  isEVMNetwork(networkId: networkId);
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
  bool isEVMNetwork({required int networkId})  {
    List<ABChainInfo> abChainInfos =   MockAbChainManagerImpl.instance.getCacheAllChainInfos();
    bool evmNetwork = false;
    for(var item in abChainInfos){
      if(item.chainId == networkId ){
        evmNetwork = item.evmChainId != null;
        break;
      }
    }
    return evmNetwork;
  }

  @override
  void pushDebugPage() {
    // TODO: implement pushDebugPage
  }

  @override
  // TODO: implement rpcClient
  ABWeb3RPCClient get rpcClient => throw UnimplementedError();

}