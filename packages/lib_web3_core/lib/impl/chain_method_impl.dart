import 'package:decimal/decimal.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_web3_core/interaction/chains/evm.dart';
import 'package:lib_web3_core/interaction/chains/solana.dart';
import 'package:lib_web3_core/interaction/signer/signer.dart';
import 'package:lib_web3_core/interaction/transaction/transaction.dart';
import 'package:lib_web3_core/interaction/txoptions/tx_option.dart';
import 'package:lib_web3_core/interface/chain_method_interface.dart';
import 'package:lib_web3_core/lib_web3_core.dart';
import 'dart:typed_data';


extension ABWeb3ChainExtension on ABWeb3Chain{

  Future<int> decimals({String? tokenAddress}) async {
    return ABWeb3CoreModule.instance.decimals(networkId: networkId, tokenAddress: tokenAddress);
  }

  Future<Decimal> decimalsFactor({String? tokenAddress}) async {
    final value = await decimals(tokenAddress: tokenAddress);
    return Decimal.fromBigInt(BigInt.from(10).pow(value));
  }

  Future<Decimal> convertBigIntToDecimal(BigInt value, {String? tokenAddress}) async {
    ABLogger.e("获取到的余额带精度值convertBigIntToDecimal:--->$value --- $tokenAddress");
    final decimalsValue = await decimals(tokenAddress: tokenAddress);
    final factor = Decimal.fromBigInt(BigInt.from(10).pow(decimalsValue));
    return (Decimal.fromBigInt(value) / factor).toDecimal(scaleOnInfinitePrecision: decimalsValue);
  }

  Future<BigInt> convertDecimalToBigInt(Decimal value, {String? tokenAddress}) async {
    final decimalsValue = await decimals(tokenAddress: tokenAddress);
    final factor = Decimal.fromBigInt(BigInt.from(10).pow(decimalsValue));
    return (value * factor).toBigInt();
  }
}

extension ABWeb3ChainFactory on ABWeb3NetworkId {
  static ABWeb3Chain<ABWeb3Transaction, ABWeb3SignedTransaction, ABWeb3SentTransaction> create(ABWeb3NetworkId networkId)  {
   bool result =    ABWeb3CoreModule.instance.isEVMNetwork(networkId: networkId);

   ABLogger.e("当前结果：$result");
    if (result) {
      return ABWeb3EVMChainWrapper(networkId);
    }
    switch (networkId) {
      case 'SOL':
        return ABWeb3SolanaChainWrapper(networkId);
      // case 'TRX':
      // case 'TRON':
      //   return ABWeb3TronChainWrapper();
      // case 'TON':
      //   return ABWeb3TonNetworkWrapper();
      // case 'SUI':
      //   return ABWeb3SuiNetworkWrapper();
      // case 'BTC':
      //   return ABWeb3BitcoinNetworkWrapper(networkId);
      // case 'APT':
      // case 'APTOS':
      //   return ABWeb3AptosNetworkWrapper(networkId);
      default:
        throw UnimplementedError();
    }
  }
}

final class ABWeb3EVMChainWrapper extends ABWeb3Chain with ABWeb3ChainApprovable {
  ABWeb3EVMChainWrapper(super.networkId)
      : network = ABEVMChains(networkId),
        super.internal();

  final ABEVMChains network;

  @override
  Future<String> get name => network.name;

  @override
  Future<String> get symbol => network.symbol;

  @override
  Future<Decimal> balance({required String address}) {
    ABLogger.e("获取余额:--->${network==null}");
    return network.getBalance(address: address).then((value) => convertBigIntToDecimal(value));
  }

  @override
  Future<Decimal> tokenBalance({required String address, required String tokenAddress}) {
    return network
        .getErc20TokenBalance(address: address, tokenAddress: tokenAddress)
        .then((value) => convertBigIntToDecimal(value, tokenAddress: tokenAddress));
  }

  @override
  Future<ABWeb3Transaction> buildContractTx({
    String? from,
    String? contractAddress,
    required Uint8List data,
    Decimal? value,
    ABWeb3ChainBuildTxOptions? options,
  }) async {
    if (from == null || contractAddress == null) {
      throw ArgumentError('from and contractAddress must not be null');
    }
    final valueBigInt = value == null ? BigInt.zero : await convertDecimalToBigInt(value);
    return network.buildContractTx(from: from, contractAddress: contractAddress, data: data, value: valueBigInt);
  }

  @override
  Future<ABWeb3Transaction> buildTransferTx({required String from, required String to, required Decimal amount}) async {
    return network.buildTransferTx(
      from: from,
      to: to,
      amount: await convertDecimalToBigInt(amount),
    );
  }

  @override
  Future<ABWeb3Transaction> buildTokenTransferTx(
      {required String from, required String to, required Decimal amount, required String tokenAddress}) async {
    return network.buildErc20TokenTransferTx(
      from: from,
      to: to,
      amount: await convertDecimalToBigInt(amount, tokenAddress: tokenAddress),
      tokenAddress: tokenAddress,
    );
  }

  @override
  Future<Decimal> estimateGas({required ABWeb3Transaction tx}) {
    if (tx is! ABWeb3EVMTransaction) {
      throw ArgumentError('tx must be ABWeb3EVMTransaction');
    }
    return network.estimateGas(tx: tx).then((value) => convertBigIntToDecimal(value));
  }

  @override
  Future<List<ABWeb3SignedTransaction>> signTxs({required List<ABWeb3Transaction> txs, required ABWeb3Signer signer}) {
    if (txs.any((tx) => tx is! ABWeb3EVMTransaction)) {
      throw ArgumentError('txs must be ABWeb3EVMTransaction');
    }
    return network.signTxs(txs: txs.cast(), signer: signer);
  }

  @override
  Future<List<ABWeb3SentTransaction>> sendTxs({required List<ABWeb3SignedTransaction> signedTxs}) {
    if (signedTxs.any((tx) => tx is! ABWeb3EVMSignedTransaction)) {
      throw ArgumentError('signedTxs must be ABWeb3EVMSignedTransaction');
    }
    return network.sendTxs(txs: signedTxs.cast());
  }

  @override
  Future<Decimal> allowance({required String tokenAddress, required String owner, required String spender}) {
    return network
        .allowance(tokenAddress: tokenAddress, owner: owner, spender: spender)
        .then((value) => convertBigIntToDecimal(value, tokenAddress: tokenAddress));
  }

  @override
  Future<ABWeb3Transaction> buildApproveTx({
    required String tokenAddress,
    required String owner,
    required String spender,
    Decimal? amount,
    ABWeb3ChainBuildTxOptions? options,
  }) async {
    BigInt? bigIntAmount;
    if (amount != null) {
      bigIntAmount = await convertDecimalToBigInt(amount, tokenAddress: tokenAddress);
    }
    return network.buildApproveTx(
      tokenAddress: tokenAddress,
      owner: owner,
      spender: spender,
      amount: bigIntAmount,
      isEnablingEIP1559: options?.asEvm?.isEnablingEIP1559,
    );
  }
}

final class ABWeb3SolanaChainWrapper
    extends ABWeb3Chain<ABWeb3Transaction, ABWeb3SignedTransaction, ABWeb3SentTransaction> {
  ABWeb3SolanaChainWrapper(super.networkId)
      : network = ABSolanaChains(),
        super.internal();

  final ABSolanaChains network;

  @override
  Future<String> get name => network.name;

  @override
  Future<String> get symbol => network.symbol;

  @override
  Future<Decimal> balance({required String address}) {
    return network.getBalance(address: address).then((value) => convertBigIntToDecimal(value));
  }

  @override
  Future<Decimal> tokenBalance({required String address, required String tokenAddress}) {
    return network
        .getSplTokenBalance(address: address, tokenAddress: tokenAddress)
        .then((value) => convertBigIntToDecimal(value, tokenAddress: tokenAddress));
  }

  @override
  Future<ABWeb3SOLTransaction> buildTransferTx(
      {required String from, required String to, required Decimal amount}) async {
    return network.buildTransferTx(
      from: from,
      to: to,
      amount: await convertDecimalToBigInt(amount),
    );
  }

  @override
  Future<ABWeb3SOLTransaction> buildTokenTransferTx(
      {required String from, required String to, required Decimal amount, required String tokenAddress}) async {
    return network.buildSplTokenTransferTx(
      from: from,
      to: to,
      amount: await convertDecimalToBigInt(amount, tokenAddress: tokenAddress),
      tokenAddress: tokenAddress,
      decimals: await decimals(tokenAddress: tokenAddress),
    );
  }

  @override
  Future<ABWeb3SOLTransaction> buildContractTx({
    String? from,
    String? contractAddress,
    required Uint8List data,
    Decimal? value,
    ABWeb3ChainBuildTxOptions? options,
  }) async {
    final valueBigInt = value == null ? BigInt.zero : await convertDecimalToBigInt(value);
    return network.buildContractTx(rawTx: data, value: valueBigInt);
  }

  @override
  Future<Decimal> estimateGas({required ABWeb3Transaction tx}) {
    return network.estimateGas(tx: tx as ABWeb3SOLTransaction).then((value) => convertBigIntToDecimal(value));
  }

  @override
  Future<List<ABWeb3SignedTransaction>> signTxs({required List<ABWeb3Transaction> txs, required ABWeb3Signer signer}) {
    return Future.wait(txs.map((tx) => network.signTx(tx: tx as ABWeb3SOLTransaction, signer: signer)));
  }

  @override
  Future<List<ABWeb3SentTransaction>> sendTxs({required List<ABWeb3SignedTransaction> signedTxs}) {
    return Future.wait(signedTxs.map((tx) => network.sendTx(tx: tx as ABWeb3SOLSignedTransaction)));
  }
}
