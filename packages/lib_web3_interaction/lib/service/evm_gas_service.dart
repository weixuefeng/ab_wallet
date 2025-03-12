import 'package:lib_web3_core/interaction/gas/gas.dart';
import 'package:lib_web3_core/interaction/gas/model/evm.dart';
import 'package:lib_web3_core/interaction/provider/gas_provider.dart';

class ABWeb3EVMGasService extends ABWeb3GasService {
  ABWeb3EVMGasService._();

  static ABWeb3EVMGasService? _instance;

  static ABWeb3EVMGasService get instance {
    return _instance ??= ABWeb3EVMGasService._();
  }

  @override
  Future<EvmGasPriceModel> getGasPrice(int networkId) async {
    throw UnimplementedError();
  }

  @override
  Future<EvmGasLimitModel> getGasLimit(int networkId, ABWeb3GasLimitRequestParams params) {
    throw UnimplementedError();
  }
}
