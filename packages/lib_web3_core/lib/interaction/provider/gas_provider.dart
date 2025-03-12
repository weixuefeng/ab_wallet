import 'package:lib_web3_core/interaction/gas/gas.dart';
import 'package:lib_web3_core/interaction/gas/model/evm.dart';

abstract class ABWeb3GasService {
  Future<ABWeb3GasPrice> getGasPrice(int networkId);

  Future<ABWeb3GasLimit> getGasLimit(
    int networkId,
    ABWeb3GasLimitRequestParams params,
  );
}

class ABWeb3GasSelectorProviderManager {
  ABWeb3GasSelectorProviderManager._();

  static ABWeb3GasSelectorProviderManager? _gTWeb3GasSelectorProviderManager;

  static ABWeb3GasSelectorProviderManager get instance {
    return _gTWeb3GasSelectorProviderManager ??= ABWeb3GasSelectorProviderManager._();
  }

  late IABWeb3GasSelectorProvider provider;

  /// 注册选择 Gas 页面的 Provider
  void register(IABWeb3GasSelectorProvider provider) {
    this.provider = provider;
  }
}

/// 选择 Gas 页面的 Provider
/// 未实现表示不支持选择 Gas
/// 【需要外部注册实现】
abstract class IABWeb3GasSelectorProvider {
  /// 选择 EVM 网络的 Gas 费，快/慢/平均
  Future<ABWeb3EVMGasFee?> evm({
    required ABWeb3EVMGasFee fast,
    required ABWeb3EVMGasFee average,
    required ABWeb3EVMGasFee slow,
    required bool isEIP1559,
  });

  /// 选择 Solana 网络的 Gas 费，快/慢/平均
  // Future<ABWeb3SolGasFee?> solana({
  //   required ABWeb3SolGasFee fast,
  //   required ABWeb3SolGasFee average,
  //   required ABWeb3SolGasFee slow,
  // });

  /// 选择 Bitcoin 网络的 Gas 费，快/慢/平均
  // Future<ABWeb3BitcoinFeeRate?> bitcoin({
  //   required ABWeb3BitcoinFeeRate fast,
  //   required ABWeb3BitcoinFeeRate average,
  //   required ABWeb3BitcoinFeeRate slow,
  //   required String minFeeRate,
  // });
}

