import 'package:lib_chain_manager/src/interface/ab_chain_manager_interface.dart';
import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';

class ABChainManagerImpl extends ABChainManagerInterface {
  @override
  Future<bool> addChainInfo(ABChainInfo info) {
    // TODO: implement addChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteChainInfo(ABChainInfo chainId) {
    // TODO: implement deleteChainInfo
    throw UnimplementedError();
  }

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

  @override
  Future<bool> updateChainInfo(ABChainInfo info) {
    // TODO: implement updateChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> updateChainInfoFromNet(List<ABChainInfo> info) {
    // TODO: implement updateChainInfoFromNet
    throw UnimplementedError();
  }

}
