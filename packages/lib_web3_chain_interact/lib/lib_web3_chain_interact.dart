import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_chain_manager/model/ab_chain_type.dart';
import 'package:lib_web3_chain_interact/base/i_ab_web3_core_module.dart';
import 'package:lib_web3_chain_interact/chains/impl/networks/evm/evm.dart';

final class ABWeb3CoreModuleImpl extends ABWeb3CoreModule {
  @override
  Future<void> debug() {
    // TODO: implement debug
    throw UnimplementedError();
  }

  @override
  getWeb3Network({required ABChainInfo chainInfo}) {
    switch (chainInfo.chainType) {
      case ABChainType.ehtereum:
        return ABWeb3EVMNetworkImpl(chainInfo: chainInfo);
      case ABChainType.other:
        return ABWeb3EVMNetworkImpl(chainInfo: chainInfo);
      default:
        throw "unSupport exception";
    }
  }
}
