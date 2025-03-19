import 'package:collection/collection.dart';
import 'package:lib_base/logger/ab_logger.dart';
import 'package:lib_chain_manager/lib_chain_manager.dart';
import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ABChainInfoNotifier extends StateNotifier<List<ABChainInfo>> {
  final MockAbChainManagerImpl _manager;

  ABChainInfoNotifier(this._manager) : super([]) {
    _initialize();
  }

  ///初始化provider中的网络数据
  Future<void> _initialize() async {
    state = await _manager.getAllChainInfos();
  }

  /// 添加链信息
  void addChain(ABChainInfo chainInfo) {
    _manager.addChainInfo(chainInfo);
    state = [...state, chainInfo];
  }

  /// 更新链信息
  void updateChain(ABChainInfo chainInfo) {
    _manager.updateChainInfo(chainInfo);
    state =
        state.map((info) {
          if (info.chainId == chainInfo.chainId) {
            return chainInfo;
          }
          return info;
        }).toList();
  }

  /// 更新来自后台的链信息
  Future<void> updateChainFromNet({
    required List<ABChainInfo> chainInfos,
  }) async {
    final updateResult = await _manager.updateChainInfoFromNet(chainInfos);
    if (updateResult) {
      state = await _manager.getAllChainInfos();
    } else {
      ABLogger.e('Failed to update chain info from net');
    }
  }

  /// 删除链信息
  Future<bool> deleteChain(int chainId) async {
    ABChainInfo? chainInfo = state.firstWhereOrNull(
      (info) => info.chainId == chainId,
    );
    if (chainInfo != null) {
      bool deleteResult = await _manager.deleteChainInfo(chainInfo);
      if (deleteResult) {
        state = state.where((info) => info.chainId != chainId).toList();
        return true;
      }
    }
    return false;
  }
}

/// 定义 Riverpod Provider
final chainInfoProvider =
    StateNotifierProvider<ABChainInfoNotifier, List<ABChainInfo>>((ref) {
      return ABChainInfoNotifier(MockAbChainManagerImpl());
    });
