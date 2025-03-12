import 'package:lib_base/lib_base.dart';
import 'package:lib_web3_core/interface/chain_method_interface.dart';

export 'interaction/signer/signer.dart';
export 'interaction/transaction/transaction.dart';
export 'interaction/chains/chains.dart';
export 'interface/chain_method_interface.dart';
export 'interface/wallet_method_interface.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

abstract class ABWeb3CoreModule {
  static ABWeb3CoreModule? _instance;

  static ABWeb3CoreModule get instance {
    assert(_instance != null, 'ABWeb3Core is not initialized');
    return _instance!;
  }

  static void init(ABWeb3CoreModule instance) {
    _instance = instance;
  }

  /// 功能调试
  Future<void> debug();

  /// 跳转到调试页面
  void pushDebugPage();

  /// 获取区块链网络实现
  dynamic getWeb3Network({required ABWeb3NetworkId networkId});

  /// 获取币种精度
  Future<int> decimals({
    required ABWeb3NetworkId networkId,
    String? tokenAddress,
  });

  /// 判断是否是EVM网络
  bool  isEVMNetwork({required ABWeb3NetworkId networkId});

  /// rpc
  ABWeb3RPCClient get rpcClient;
}

/// 处理RPC请求
abstract mixin class ABWeb3RPCClient {
  Future<Map<String, dynamic>> post({
    required Uri uri,
    required dynamic body,
    Map<String, String> headers = const {'Content-Type': 'application/json'},
  });

  /// 构建 Post 签名请求头
  /// [uri] 请求地址
  /// [body] 请求体
  /// [headers] 请求头
  /// 返回签名后的请求头
  Future<Map<String, String>> makePostSignHeaders({
    required Uri uri,
    required dynamic body,
    Map<String, String> headers = const {'Content-Type': 'application/json'},
  });

  factory ABWeb3RPCClient() => ABWeb3CoreModule.instance.rpcClient;
}

/// rpc、REST管理
abstract class ABWeb3ChainRpcAddressProvider {

  const ABWeb3ChainRpcAddressProvider();

  static void init(ABWeb3ChainRpcAddressProvider instance) => _instance = instance;


  /// 确保初始化
  Future<void> ensureInitialized();

  /// 返回所有的 rpc 地址
  Future<List<String>> rpcAddresses(ABWeb3NetworkId networkId);

  /// 返回所有的 rest 地址
  Future<List<String>> restAddresses(ABWeb3NetworkId networkId);

  /// 返回 EVM 网络的 rpc 地址
  /// [chainId] 链 ID
  Future<String?> evmRpcAddress(String chainId);

  static ABWeb3ChainRpcAddressProvider? _instance;

  static ABWeb3ChainRpcAddressProvider get instance {
    assert(_instance != null, 'ABWeb3NetworkRpcAddressProvider is not initialized');
    return _instance!;
  }

  /// 返回当前选择的 rpc 地址
  Future<String> rpcAddress(ABWeb3NetworkId networkId) async {
    return rpcAddresses(networkId).then((addresses) =>
    addresses.first);
  }

  /// 返回当前选择的 rest 地址
  Future<String> restAddress(ABWeb3NetworkId networkId) {
    return restAddresses(networkId).then((addresses) => addresses.first);
  }

  /// 兼容适配 - 获取新的节点地址列表
  Future<Map<int, List<String>>> getRPCNodeList();

  /// 节点错误请求错误
  /// [rpcAddress] rpc 地址
  /// [error] 错误
  void onNodeError(String rpcAddress, String error);

  /// 节点请求耗时
  /// [rpcAddress] rpc 地址
  /// [duration] 耗时
  void onNodeDuration(String rpcAddress, Duration duration);

  /// 替换为竞速节点
  /// [rpcAddress] rpc 地址
  String replaceWithSpeedUpNode(String rpcAddress);
}
