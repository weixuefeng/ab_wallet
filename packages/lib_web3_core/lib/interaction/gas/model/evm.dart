

import 'package:lib_web3_core/interaction/gas/gas.dart';

abstract class ABWeb3EVMGasFee extends  ABWeb3GasFee{

  /// 在 1559 中表示 priorityGaSFee
  /// 在 legacy 中表示 gasPrice
  BigInt get gasPriceInWei;

  /// eip1559 专有字段
  BigInt get baseFeeInWei;

  /// eip1559 专有字段
  BigInt get maxFeePerGas;

  /// 某些EVM链会额外需要一个 L1的费用
  BigInt? get l1GasPrice;

  ///gas限制
  BigInt get gasLimit;

  /// 预计需要确认时间， 单位：秒
  int get time;

  bool get isEIP1559;

  Future<ABWeb3EVMGasFee> custom({
    /// 如果是 EIP1559， 这个值代表基础费， 如果是legacy 代表gasPrice
    required BigInt gasPrice,

    /// 如果是 EIP1559， 这个值代表优先费， 如果是legacy 这个值传 0
    BigInt? priorityFee,
    required BigInt gasLimit,
    int? newTime,
  });

}

class EvmGasPriceModel extends ABWeb3GasPrice {
  late final String nativeCoinPrice;
  late final BigInt lowPriWeiPerGas;
  late final BigInt avgPriWeiPerGas;
  late final BigInt fastPriWeiPerGas;
  late final BigInt baseWeiFee;
  late final bool supportEip1559;
  late final int lowPriCostTime;
  late final int avgPriCostTime;
  late final int fastPriCostTime;

  EvmGasPriceModel({
    required this.nativeCoinPrice,
    required this.lowPriWeiPerGas,
    required this.avgPriWeiPerGas,
    required this.fastPriWeiPerGas,
    required this.baseWeiFee,
    required this.supportEip1559,
    required this.lowPriCostTime,
    required this.avgPriCostTime,
    required this.fastPriCostTime,
  });
}

class EvmGasLimitModel extends ABWeb3GasLimit {
  late final int gasUsed;
  late final int approveGasUsed;

  EvmGasLimitModel({
    required this.gasUsed,
    required this.approveGasUsed,
  });
}