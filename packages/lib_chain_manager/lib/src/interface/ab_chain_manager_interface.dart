
import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';

/// 链管理为 网络支持的链管理，与钱包本身无关
abstract class ABChainManagerInterface {
  /// 获取所有链信息
  Future<List<ABChainInfo>> getAllChainInfos();

  /// 设置当前选中的链信息
  Future<bool> setSelectedChainInfo(ABChainInfo info);

  /// 更新当前的链信息
  Future<bool> updateChainInfo(ABChainInfo info);

  /// 添加链信息
  Future<bool> addChainInfo(ABChainInfo info);

  /// 删除链信息
  Future<bool> deleteChainInfo(ABChainInfo chainId);

  /// 获取当前选中的链信息
  Future<ABChainInfo?> getSelectedChainInfo();

  /// 设置 DApp 当前选中的链信息
  Future<bool> setDAppSelectedChainInfo(ABChainInfo info);

  /// 获取DApp当前选中的链信息
  Future<ABChainInfo?> getDAppSelectedChainInfo();

  /// 更新AB项目支持链信息
  Future<bool> updateChainInfoFromNet(List<ABChainInfo> info);
}
