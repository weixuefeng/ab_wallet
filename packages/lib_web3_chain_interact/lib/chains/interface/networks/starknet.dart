import 'dart:typed_data';

import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_unsigned_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

enum StarknetTransactionVersion {
  v1(1),
  v3(3);

  final int version;

  const StarknetTransactionVersion(this.version);
}

enum StarknetTransactionType { deploy, transfer }

abstract class ABWeb3StarknetNetwork {
  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// 代币余额
  /// [address] 钱包地址
  /// [tokenAddress] 代币地址
  /// return 余额
  Future<BigInt> getTokenBalance({required String address, required String tokenAddress});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3StarknetTransaction]
  Future<ABWeb3StarknetTransaction> buildTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required StarknetTransactionVersion transactionVersion,
  });

  /// 构建账户部署交易
  /// [address] 需要部署的账户
  /// [transactionVersion] 部署协议版本 v1, v3
  /// return 交易 [ABWeb3StarknetTransaction]
  Future<ABWeb3StarknetTransaction> buildDeployTx({
    required String address,
    required StarknetTransactionVersion transactionVersion,
  });

  /// 构建代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [tokenAddress] 代币合约地址
  /// return 交易 [ABWeb3StarknetTransaction]
  Future<ABWeb3StarknetTransaction> buildTokenTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String tokenAddress,
    required StarknetTransactionVersion transactionVersion,
  });

  /// 构建合约交易
  /// [from] 发送地址
  /// [contractAddress] 合约地址
  /// [data] 数据
  /// return 交易 [ABWeb3StarknetTransaction]
  Future<ABWeb3StarknetTransaction> buildContractTx({
    required String from,
    required String contractAddress,
    required Uint8List data,
    required StarknetTransactionVersion transactionVersion,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3StarknetTransaction tx});

  /// 签名多笔交易
  /// [txs] 交易列表
  /// return 签名后的交易列表
  Future<List<ABWeb3StarknetSignedTransaction>> signTxs({
    required List<ABWeb3StarknetTransaction> txs,
    required ABWeb3Signer signer,
  });

  /// 广播多笔交易
  /// [txs] 交易列表
  /// return 已发送的交易列表
  Future<List<ABWeb3StarknetSentTransaction>> sendTxs({required List<ABWeb3StarknetSignedTransaction> txs});
}

/// Starknet 交易
abstract class ABWeb3StarknetTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  String? get tokenContract;

  Uint8List? get data;

  BigInt? get maxFeeV1;

  BigInt? get gasV3;

  BigInt? get gasPriceV3;

  StarknetTransactionVersion get transactionVersion;

  StarknetTransactionType get transactionType;

  void setMaxFeeV1(BigInt maxFeeV1);

  void setGasV3(BigInt gasV3);

  void setGasPriceV3(BigInt gasPriceV3);

  @override
  String toString() {
    return {
      "from": from,
      "to": to,
      "value": value.toString(),
      "tokenContract": tokenContract,
      "data": data,
      "maxFeeV1": maxFeeV1,
      "gasV3": gasV3,
      "gasPriceV3": gasPriceV3,
    }.toString();
  }
}

/// Starknet 签名后的交易
abstract class ABWeb3StarknetSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// Starknet 未签名的交易
abstract class ABWeb3StarknetUnsignedTransaction extends ABWeb3UnsignedTransaction {}

/// Starknet 已发送的交易
abstract class ABWeb3StarknetSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}
