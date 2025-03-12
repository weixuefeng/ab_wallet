import 'package:decimal/decimal.dart';

import 'package:lib_web3_core/interaction/gas/gas.dart';
import 'package:lib_web3_core/interaction/gas/model/evm.dart';
import 'package:lib_web3_core/interface/chain_method_interface.dart';

class ABWeb3EvmGasFeeLevel extends ABWeb3GasFeeLevels {
  @override
  ABWeb3EVMGasFeeImpl low;
  @override
  ABWeb3EVMGasFeeImpl avg;
  @override
  ABWeb3EVMGasFeeImpl fast;
  @override
  ABWeb3EVMGasFeeImpl? custom;
  final bool isEIP1559;

  ABWeb3EvmGasFeeLevel({
    required this.low,
    required this.avg,
    required this.fast,
    required this.isEIP1559,
  });

  ABWeb3EVMGasFeeImpl getGasFeeByType(GasFeeType? type) {
    switch (type) {
      case GasFeeType.low:
        return low;
      case GasFeeType.avg:
        return avg;
      case GasFeeType.fast:
        return fast;
      default:
        return fast;
    }
  }

  @override
  void setCustom(ABWeb3GasFee custom) {
    assert(custom is ABWeb3EVMGasFeeImpl);
    this.custom = custom as ABWeb3EVMGasFeeImpl;
  }
}

class ABWeb3EVMGasFeeImpl extends ABWeb3EVMGasFee {
  @override
  final ABWeb3NetworkId networkId;

  @override
  final BigInt baseFeeInWei;

  @override
  final BigInt maxFeePerGas;

  @override
  final Decimal fee;

  @override
  final Decimal feeUSD;

  @override
  final BigInt gasPriceInWei;

  @override
  final BigInt? l1GasPrice;

  @override
  final BigInt gasLimit;

  @override
  final String symbol;

  @override
  final int time;

  @override
  final GasFeeType type;

  @override
  final bool isEIP1559;

  final Decimal coinPrice;

  ABWeb3EVMGasFeeImpl({
    required this.networkId,
    required this.baseFeeInWei,
    required this.maxFeePerGas,
    required this.fee,
    required this.feeUSD,
    required this.gasPriceInWei,
    required this.symbol,
    required this.time,
    required this.type,
    required this.gasLimit,
    required this.coinPrice,
    required this.isEIP1559,
    this.l1GasPrice,
  });

  @override
  Future<ABWeb3EVMGasFee> custom({
    required BigInt gasPrice,
    BigInt? priorityFee,
    required BigInt gasLimit,
    int? newTime,
  }) async {
    priorityFee ??= BigInt.zero;
    final totalGasFee = (priorityFee + gasPrice) * gasLimit + (l1GasPrice ?? BigInt.zero);
    final maxFeePerGas = BigInt.from(1.5 * (priorityFee + gasPrice).toDouble());
    // final fee = await ABWeb3Chain.factory(networkId).convertBigIntToDecimal(totalGasFee);
    final fee = new Decimal.fromBigInt(BigInt.one);

    final feeUSD = fee * coinPrice;
    return ABWeb3EVMGasFeeImpl(
      networkId: networkId,
      baseFeeInWei: isEIP1559 ? gasPrice : BigInt.zero,
      maxFeePerGas: maxFeePerGas,
      fee: fee,
      feeUSD: feeUSD,
      gasPriceInWei: isEIP1559 ? priorityFee : gasPrice,
      symbol: symbol,
      time: newTime ?? time,
      type: GasFeeType.custom,
      gasLimit: gasLimit,
      coinPrice: coinPrice,
      isEIP1559: isEIP1559,
    );
  }
}

class ABWeb3EVMGasLimitRequestParams extends ABWeb3GasLimitRequestParams {
  final String from;
  final String to;
  final String? data;
  final String value;
  final bool isApprove;

  ABWeb3EVMGasLimitRequestParams({
    required this.from,
    required this.to,
    this.data,
    required this.value,
    required this.isApprove,
  });
}