import 'package:lib_chain_manager/interface/ab_chain_manager_interface.dart';
import 'package:lib_chain_manager/model/ab_chain_info.dart';

class MockAbChainManagerImpl extends ABChainManagerInterface {
  @override
  Future<List<ABChainInfo>> getAllChainInfos() {
    // TODO: implement getAllChainInfos
    throw UnimplementedError();
  }

  @override
  Future<ABChainInfo?> getDAppSelectedChainInfo() {
    // TODO: implement getDAppSelectedChainInfo
    throw UnimplementedError();
  }

  @override
  Future<ABChainInfo?> getSelectedChainInfo() {
    // TODO: implement getSelectedChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> setDAppSelectedChainInfo(ABChainInfo info) {
    // TODO: implement setDAppSelectedChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> setSelectedChainInfo(ABChainInfo info) {
    // TODO: implement setSelectedChainInfo
    throw UnimplementedError();
  }
}
