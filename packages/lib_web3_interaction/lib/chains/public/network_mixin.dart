import 'package:decimal/decimal.dart';
import 'package:lib_web3_core/lib_web3_core.dart';

abstract mixin class IABWeb3Network {

  int get networkId;

  Future<String> rpcAddress() => ABWeb3ChainRpcAddressProvider.instance.rpcAddress(networkId);

  Future<String> restAddress() => ABWeb3ChainRpcAddressProvider.instance.restAddress(networkId);

  /// 是否支持硬件钱包， 默认返回false
  bool get supportHardwareSigner => false;

  // Future<Decimal> convertBigIntToDecimal(BigInt value, {String? tokenAddress}) async {
  //   return ABWeb3Chain.factory(networkId).convertBigIntToDecimal(value);
  // }

  // Future<BigInt> convertDecimalToBigInt(Decimal value, {String? tokenAddress}) async {
  //   return ABWeb3Chain.factory(networkId).convertDecimalToBigInt(value);
  // }
}
