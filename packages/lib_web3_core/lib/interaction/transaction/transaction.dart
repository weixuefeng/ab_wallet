
import 'package:lib_web3_core/interaction/chains/solana.dart';
import 'package:lib_web3_core/interaction/gas/gas.dart';

abstract class ABWeb3Transaction{
  //
  ABWeb3SOLTransaction? get asSOLTransaction => this as ABWeb3SOLTransaction?;

  ///网络唯一id
  int get networkId;

  /// 预估手续费，如有多种级别手续费，默认返回一个级别，fast级别
  /// [ABWeb3GasFee] 如果这个值是null，则正常更新gas， 如果有值，说明是用户自定义，直接返回
  /// [gasFeeType] 指定返回什么类型的gas fee，默认 fast， 如果ABWeb3GasFee 有值， 则优先使用， 忽略gasFeeType，
  Future<ABWeb3GasFee> estimateGasV2({ABWeb3GasFee? abWeb3GasFee, GasFeeType gasFeeType = GasFeeType.fast}) =>
      throw UnimplementedError('not support with network $networkId');

  /// 预估手续费，返回所有级别手续费, 用在有选择快中慢的链
  /// 和estimateGasV2 的区别：V2版本只返回单个级别的手续费，适用于没有快中慢选择的链，且默认选中快的链可以用V2，否则使用V3， 返回参数更多
  /// [abWeb3GasFee] 如果这个值是null，则正常更新gas， 如果有值，说明是用户自定义，直接返回
  /// [gasFeeType] 指定用什么类型的gas fee，来更新内部交易,默认 fast
  Future<ABWeb3GasFeeLevels> estimateGasV3({
    ABWeb3GasFeeLevels? abWeb3GasFeeLevels,
    GasFeeType gasFeeType = GasFeeType.fast,
  }) =>
      throw UnimplementedError('not support with network $networkId');

  /// 预估手续费，返回快中慢全部手续费
  Future<ABWeb3GasFeeLevels> getGasFeeLevels() => throw UnimplementedError('not support with network $networkId');

  /// 用户选择 low/avg/fast/custom 后 返回一个新的交易, 不可选则不实现该方法
  Future<ABWeb3Transaction?> selectGasFee() => throw UnimplementedError('not support with network $networkId');

  /// 是否可选择手续费等级
  Future<bool> get canSelectGasFee => Future.value(false);

  /// 是否可自定义手续费
  Future<bool> get canCustom => Future.value(false);

}

/// 未签名交易
abstract class ABWeb3UnsignedTransaction {
  //
}

/// 已签名的交易
abstract class ABWeb3SignedTransaction {
  String get signedRaw;
}

/// 已发送的交易
abstract class ABWeb3SentTransaction {
  String get hash;
}