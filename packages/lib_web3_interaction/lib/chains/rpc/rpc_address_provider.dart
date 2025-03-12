import 'dart:async';

import 'package:lib_base/logger/ab_logger.dart';
import 'package:lib_chain_manager/mock/mock_ab_chain_manager_impl.dart';
import 'package:lib_chain_manager/model/ab_chain_endpoints.dart';
import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_chain_manager/model/ab_chain_info.dart';

final class ABWeb3ChainRpcAddressProviderImpl
    extends ABWeb3ChainRpcAddressProvider {
  ABWeb3ChainRpcAddressProviderImpl();

  /// RPC 节点列表
  /// key: 网络Key
  /// value: 节点列表
  static final Map<int, List<String>> _rpcNodeList = {};
  static final Map<int, List<String>> _restNodeList = {};

  /// RPC 节点网络Key
  /// key: RPC 地址
  /// value: 网络Key
  static final Map<String, int> _rpcNodeNetworkKeyMap = {};
  static final Map<String, int> _restNodeNetworkKeyMap = {};

  /// 初始化 RPC 节点列表
  Future<void> initRPCNodeList() async {
    List<ABChainInfo> chainInfos =
        await MockAbChainManagerImpl.instance.getAllChainInfos();

    /// 更新网络 RPC 地址
    void setupRPCAddress(int chainId, ABChainEndpoints networkDic) {
      /// 已存在，不覆盖
      if (_rpcNodeList.containsKey(chainId)) {
        return;
      }

      /// 只处理有 RPC 地址的网络
      if (networkDic.rpcAddresses == null || networkDic.rpcAddresses!.isEmpty) {
        return;
      }

      // /// 只处理启用 RPC 加签的网络
      // if (!_enableRPCSign(networkKey)) {
      //   return;
      // }

      /// RPC 节点列表
      _rpcNodeList[chainId] = networkDic.rpcAddresses!;
      _restNodeList[chainId] = networkDic.restfulAddresses!;

      /// RPC 节点网络Key
      for (var element in networkDic.rpcAddresses!) {
        _rpcNodeNetworkKeyMap[element] = chainId;
      }
      for (var element in networkDic.restfulAddresses!) {
        _restNodeNetworkKeyMap[element] = chainId;
      }
    }

    for (var element in chainInfos) {
      setupRPCAddress(element.chainId, element.endpoints);
    }
  }

  /// 替换为竞速节点
  /// [rpcAddress] RPC 地址
  @override
  String replaceWithSpeedUpNode(String rpcAddress) {
    /// 先简单实现，取首个，异常节点移动到末尾
    final networkKey = _rpcNodeNetworkKeyMap[rpcAddress];
    if (networkKey == null) {
      return rpcAddress;
    }
    final rpcNodeList = _rpcNodeList[networkKey];
    if (rpcNodeList == null) {
      return rpcAddress;
    }
    if (rpcNodeList.length <= 1) {
      return rpcAddress;
    }
    return rpcNodeList.first;
  }

  /// 节点错误请求错误
  /// [rpcAddress] RPC 地址
  /// [error] 错误
  @override
  void onNodeError(String rpcAddress, String error) {
    /// 移动到末尾
    final networkKey = _rpcNodeNetworkKeyMap[rpcAddress];
    if (networkKey == null) {
      return;
    }
    final rpcNodeList = _rpcNodeList[networkKey];
    if (rpcNodeList == null) {
      return;
    }
    if (rpcNodeList.length <= 1) {
      return;
    }
    rpcNodeList.remove(rpcAddress);
    rpcNodeList.add(rpcAddress);
  }

  /// 节点请求耗时
  /// [rpcAddress] RPC 地址
  /// [duration] 耗时
  @override
  void onNodeDuration(String rpcAddress, Duration duration) {}

  /// 启用 RPC 加签的网络
  // bool _enableRPCSign(String networkKey) {
  //   /// EVM 网络
  //   return WalletNetworkMethod.isEVMNetwork(networkKey: networkKey);
  // }

  @override
  Future<List<String>> rpcAddresses(int networkId) async {
    ABLogger.e('当前_rpcNodeList长度--->${_rpcNodeList.length}');
    return _rpcNodeList[networkId] ?? [];
  }

  @override
  Future<List<String>> restAddresses(int networkId) async {
    return _restNodeList[networkId] ?? [];
  }

  @override
  Future<Map<int, List<String>>> getRPCNodeList() async {
    return _rpcNodeList;
  }

  @override
  Future<void> ensureInitialized() async {
    initRPCNodeList();
    return;
  }

  @override
  Future<String?> evmRpcAddress(String chainId) async {
    List<ABChainInfo> list =
        await MockAbChainManagerImpl.instance.getAllChainInfos();

    final index = list.indexWhere((element) => element.evmChainId == chainId);
    if (index == -1) {
      return Future.value(null);
    }
    final network = list[index];
    if (network.endpoints.selectedEndpoints != null) {
      return Future.value(network.endpoints.selectedEndpoints);
    }
    if (network.endpoints.rpcAddresses == null ||
        network.endpoints.rpcAddresses!.isEmpty) {
      return Future.value(null);
    }
    return Future.value(network.endpoints.rpcAddresses!.first);
  }
}
