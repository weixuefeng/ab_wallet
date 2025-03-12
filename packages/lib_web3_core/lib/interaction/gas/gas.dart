import 'package:decimal/decimal.dart';
import 'package:lib_web3_core/interface/chain_method_interface.dart';
import 'package:lib_web3_core/lib_web3_core.dart';

enum GasFeeType {
  low,
  avg,
  fast,
  custom;
}

abstract class ABWeb3GasPrice {}

abstract class ABWeb3GasLimit {}

abstract class ABWeb3GasLimitRequestParams {}

/// 区块链交易的 Gas 费
abstract class ABWeb3GasFee {
  ABWeb3NetworkId get networkId;

  /// 单位,如: ETH
  String get symbol;

  /// 显示给用户看的总手续费， 如0.000012
  Decimal get fee;

  /// fee 数量等价美元
  Decimal get feeUSD;

  /// low， avg， fast，custom
  GasFeeType get type;
}

abstract class ABWeb3GasFeeLevels {
  ABWeb3GasFee get low;

  ABWeb3GasFee get avg;

  ABWeb3GasFee get fast;

  /// 有些链没有自定义
  ABWeb3GasFee? get custom;

  void setCustom(ABWeb3GasFee custom);
}


