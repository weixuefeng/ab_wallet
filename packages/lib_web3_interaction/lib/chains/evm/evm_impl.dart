
import 'dart:typed_data';

import 'package:lib_base/lib_base.dart';
import 'package:lib_web3_core/interaction/chains/evm.dart';
import 'package:lib_web3_core/interaction/signer/signer.dart';
import 'package:lib_web3_core/interface/chain_method_interface.dart';
import 'package:lib_web3_core/rpc/evm_chain_method.dart';
import 'package:lib_web3_interaction/chains/evm/transaction_impl.dart';
import 'package:lib_web3_interaction/chains/public/functions.dart';
import 'package:lib_web3_interaction/chains/public/network_mixin.dart';

final class ABWeb3EVMChainImpl extends ABEVMChains  with IABWeb3Network{

  ABWeb3EVMChainImpl({required ABWeb3NetworkId networkId}): super.internal(networkId);

  @override
  Future<String> get name => getNameByNetworkId(networkId);

  @override
  Future<String> get symbol => getSymbolByNetworkId(networkId);

  EVMChainMethod? _method;

  Future<EVMChainMethod> getRpcMethod() async {
   String rpc =  await rpcAddress();
    _method ??= EVMChainMethod(rpc);

    ABLogger.e('当前rpc地址：$rpc');
    return _method!;
  }

  @override
  Future<ABWeb3EVMTransaction> buildEIP4844Tx({required String from, required String to, required BigInt amount, required Sidecar sidecar}) async {
    return ABWeb3EVMTransactionImpl(
      networkId: networkId,
      from: from,
      to: to,
      value: amount,
      sidecar: sidecar,
    );
  }

  @override
  Future<ABWeb3EVMTransaction> buildErc20TokenTransferTx({required String from, required String to, required BigInt amount, required String tokenAddress}) async {
    if(from.isEmpty || to.isEmpty) throw ArgumentError("from and to address can not be empty");
    final method = await getRpcMethod();
    final data = method.encodeERC20Transfer(from, to, amount);
    return ABWeb3EVMTransactionImpl(
      networkId: networkId,
      from: from,
      to: tokenAddress,
      value: BigInt.zero,
      data: data,
    );
  }

  @override
  Future<ABWeb3EVMTransaction> buildTransferTx({required String from, required String to, required BigInt amount}) {
    // TODO: implement buildTransferTx
    throw UnimplementedError();
  }

  @override
  Future<BigInt> getBalance({required String address}) async {
    ABLogger.e("获取余额：$address");
    final balance = await (await getRpcMethod()).getBalance(address);
    return balance;
  }

  @override
  Future<BigInt> getErc20TokenBalance({required String address, required String
  tokenAddress}) async {
    final balance = await (await getRpcMethod()).getTokenBalance(tokenAddress, address);
    return balance;
  }

  @override
  Future<BigInt> allowance({required String owner, required String spender, required String tokenAddress}) {
    // TODO: implement allowance
    throw UnimplementedError();
  }

  @override
  Future<ABWeb3EVMTransaction> buildApproveTx({required String owner, required String spender, required String tokenAddress, required BigInt? amount, bool? isEnablingEIP1559}) {
    // TODO: implement buildApproveTx
    throw UnimplementedError();
  }

  @override
  Future<ABWeb3EVMTransaction> buildContractTx({required String from, required String contractAddress, required Uint8List data, required BigInt value, bool? isEnablingEIP1559}) {
    // TODO: implement buildContractTx
    throw UnimplementedError();
  }

  @override
  Future<ABWeb3EVMUnsignedTransaction> buildUnsignedTx({required ABWeb3EVMTransaction tx}) {
    // TODO: implement buildUnsignedTx
    throw UnimplementedError();
  }

  @override
  Future<BigInt> estimateGas({required ABWeb3EVMTransaction tx}) {
    // TODO: implement estimateGas
    throw UnimplementedError();
  }

  @override
  Future<BigInt> getL1Gas({required Uint8List tx, required int networkId}) {
    // TODO: implement getL1Gas
    throw UnimplementedError();
  }

  @override
  Future<List<ABWeb3EVMSentTransaction>> sendTxs({required List<ABWeb3EVMSignedTransaction> txs}) {
    // TODO: implement sendTxs
    throw UnimplementedError();
  }

  @override
  Future<List<ABWeb3EVMSignedTransaction>> signTxs({required List<ABWeb3EVMTransaction> txs, required ABWeb3Signer
  signer}) {
    // TODO: implement signTxs
    throw UnimplementedError();
  }

}