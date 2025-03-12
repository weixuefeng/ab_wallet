import 'dart:typed_data';
import 'package:lib_web3_core/interaction/chains/solana.dart';
import 'package:lib_web3_core/interaction/signer/signer.dart';
import 'package:lib_web3_core/interface/chain_method_interface.dart';

final class ABWeb3SOLChainImpl extends ABSolanaChains {

  ABWeb3SOLChainImpl({required ABWeb3NetworkId networkId})  : super.internal();

  // ChainSolMethod? _rpcMethod;


  @override
  Future<ABWeb3SOLTransaction> buildContractTx({required Uint8List rawTx, required BigInt value}) {
    // TODO: implement buildContractTx
    throw UnimplementedError();
  }

  @override
  Future<ABWeb3SOLTransaction> buildSplTokenTransferTx({required String from, required String to, required BigInt amount, required String tokenAddress, required int decimals}) {
    // TODO: implement buildSplTokenTransferTx
    throw UnimplementedError();
  }

  @override
  Future<ABWeb3SOLTransaction> buildTransferTx({required String from, required String to, required BigInt amount}) {
    // TODO: implement buildTransferTx
    throw UnimplementedError();
  }

  @override
  Future<BigInt> estimateGas({required ABWeb3SOLTransaction tx}) {
    // TODO: implement estimateGas
    throw UnimplementedError();
  }

  @override
  Future<BigInt> getBalance({required String address}) {
    // TODO: implement getBalance
    throw UnimplementedError();
  }

  @override
  Future<BigInt> getSplTokenBalance({required String address, required String tokenAddress}) {
    // TODO: implement getSplTokenBalance
    throw UnimplementedError();
  }

  @override
  Future<BigInt> getTransferRent({required String from, required String to, String? tokenAddress}) {
    // TODO: implement getTransferRent
    throw UnimplementedError();
  }

  @override
  // TODO: implement name
  Future<String> get name => throw UnimplementedError();

  @override
  Future<ABWeb3SOLSentTransaction> sendTx({required ABWeb3SOLSignedTransaction tx}) {
    // TODO: implement sendTx
    throw UnimplementedError();
  }

  @override
  Future<ABWeb3SOLSignedTransaction> signTx({required ABWeb3SOLTransaction tx, required ABWeb3Signer
  signer}) {
    // TODO: implement signTx
    throw UnimplementedError();
  }

  @override
  // TODO: implement symbol
  Future<String> get symbol => throw UnimplementedError();





}