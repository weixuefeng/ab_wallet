import 'package:lib_chain_manager/model/ab_chain_info.dart';

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

  /// 获取区块链网络实现
  dynamic getWeb3Network({required ABChainInfo chainInfo});
}
