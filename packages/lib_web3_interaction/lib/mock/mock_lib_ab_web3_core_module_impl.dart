
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/model/ab_chain_type.dart';
import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_chain_manager/mock/mock_ab_chain_manager_impl.dart';
import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_web3_interaction/chains/evm/evm_impl.dart';
import 'package:lib_web3_interaction/chains/solana/solana_impl.dart';
import 'package:lib_web3_interaction/test/solana_test.dart';

class MockLibABWeb3CoreModuleImpl extends ABWeb3CoreModule{

  MockLibABWeb3CoreModuleImpl._internal();

  static final  MockLibABWeb3CoreModuleImpl instance =  MockLibABWeb3CoreModuleImpl._internal();

  factory MockLibABWeb3CoreModuleImpl(){
    return instance;
  }

  @override
  Future<void> debug() async {
    SolanaTest().test();
  }

  @override
  Future<int> decimals({required int networkId, String? tokenAddress}) {
    int decimal = 6;
    ABLogger.e('如何获取20代币的精度');
    // TODO: tokenAddress == null去网络信息中拿，否则根据networkId和tokenAddress去缓存库拿，拿不到去代币库拿或者链上拿
    return Future.value(decimal) ;
  }

  @override
  dynamic getWeb3Network({required int networkId})  {
    ABChainInfo? abChainInfo = MockAbChainManagerImpl.instance.getChainInfoByChainId(networkId);
    assert(abChainInfo!=null,'ABChainInfo cannot be null');
    //TODO: abChainInfo 不能为空
    switch (abChainInfo!.chainType) {
      case ABChainType.ehtereum:
        return ABWeb3EVMChainImpl(networkId: networkId);
      case ABChainType.solana:
        return ABWeb3SOLChainImpl(networkId: networkId);
      default:
        throw Exception('Unsupported network: $networkId');
    }
  }

  @override
  bool isEVMNetwork({required int networkId})  {
    List<ABChainInfo> abChainInfos =  MockAbChainManagerImpl.instance.getCacheAllChainInfos();
    bool evmNetwork = false;
    for(var item in abChainInfos){
      if(item.chainId == networkId ){
        evmNetwork = item.chainType == ABChainType.ehtereum;
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