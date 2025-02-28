import 'package:lib_chain_manager/model/ab_chain_info.dart';

/// 链管理为 网络支持的链管理，与钱包本身无关
abstract class ABChainManagerInterface {
  /// 获取所有链信息
  Future<List<ABChainInfo>> getAllChainInfos();

  /// 设置当前选中的链信息
  Future<bool> setSelectedChainInfo(ABChainInfo info);

  /// 获取当前选中的链信息
  Future<ABChainInfo?> getSelectedChainInfo();

  /// 设置 DApp 当前选中的链信息
  Future<bool> setDAppSelectedChainInfo(ABChainInfo info);

  /// 获取DApp当前选中的链信息
  Future<ABChainInfo?> getDAppSelectedChainInfo();
}
