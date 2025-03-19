import 'package:lib_chain_manager/src/providers/ab_chain_global_providers.dart';
export 'src/impl/ab_chain_manager_impl.dart';
export 'src/mock/mock_ab_chain_manager_impl.dart';
export 'src/model/ab_chain_type.dart';
export 'src/db_model/ab_chain_info.dart';
export 'src/utils/ab_chain_utils.dart';
export 'src/utils/ab_token_adapter_extension.dart';
export 'src/providers/ab_chain_info_provider.dart';
export 'src/utils/ab_chain_info_extension.dart';

/// The manager of lib_chain_manager
class LibChainManager {
  LibChainManager._internal();

  static final LibChainManager _instance = LibChainManager._internal();

  static LibChainManager get instance => _instance;

  void destroy() {
    libChainManagerProviderContainer.dispose();
  }
}
