import 'package:collection/collection.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';
import 'package:lib_chain_manager/src/providers/ab_chain_info_provider.dart';

class ABChainUtils {
  /// 根据 chainId 获取链信息
  static ABChainInfo? getChainById(int chainId) {
    return abGlobalProviderContainer
        .read(chainInfoProvider)
        .firstWhereOrNull((info) => info.chainId == chainId);
  }

  /// 根据 chainId 获取链信息
  static List<ABChainInfo> getAllChains() {
    return abGlobalProviderContainer
        .read(chainInfoProvider);
  }

}
