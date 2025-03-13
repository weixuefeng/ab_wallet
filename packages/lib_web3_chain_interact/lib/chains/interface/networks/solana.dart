import 'dart:typed_data';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3SolanaNetwork {
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
  Future<BigInt> getSplTokenBalance({required String address, required String tokenAddress});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3SOLTransaction]
  Future<ABWeb3SOLTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 构建 SplToken 代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [tokenAddress] 代币合约地址
  /// [decimals] 代币精度
  /// return 交易 [ABWeb3SOLTransaction]
  Future<ABWeb3SOLTransaction> buildSplTokenTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String tokenAddress,
    required int decimals,
  });

  /// 构建合约交易
  /// [rawTx] base64 的交易原生数据
  /// [value] 交易中SOL的数量
  /// return 交易 [ABWeb3SOLTransaction]
  Future<ABWeb3SOLTransaction> buildContractTx({required Uint8List rawTx, required BigInt value});

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3SOLTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3SOLSignedTransaction> signTx({required ABWeb3SOLTransaction tx, required ABWeb3Signer signer});

  /// 广播多笔交易
  /// [tx] 交易
  /// return 已发送的交易
  Future<ABWeb3SOLSentTransaction> sendTx({required ABWeb3SOLSignedTransaction tx});

  /// 发送交易的账户租金,  减去返回结果后相当于可用余额
  /// [from] 发送地址
  /// [to] 接收地址
  /// [tokenAddress] 代币地址
  /// Return 租金
  Future<BigInt> getTransferRent({required String from, required String to, String? tokenAddress});
}

/// SOL 交易
abstract class ABWeb3SOLTransaction extends ABWeb3Transaction {
  int? get priorityPrice;

  int? get computedUintLimit;

  void setPriorityPrice(int priorityPrice);

  void setComputedUnitLimit(int computedUnitLimit);

  // 签名数量
  int get signatureCount => throw UnimplementedError();
}

/// SOL 签名后的交易
abstract class ABWeb3SOLSignedTransaction extends ABWeb3SignedTransaction {
  //
}

/// SOL 已发送的交易
abstract class ABWeb3SOLSentTransaction extends ABWeb3SentTransaction {
  //
}
