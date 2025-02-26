import 'package:lib_chain_manager/model/ab_chain_info.dart';

abstract class ABChainManagerInterface {
  /// 获取所有链信息
  Future<List<ABChainInfo>> getAllChainInfos();

  /// 设置当前选中的链信息
  Future<bool> setSelectedChainInfo(ABChainInfo info);

  /// 获取当前选中的链信息
  Future<ABChainInfo?> getSelectedChainInfo();
}
