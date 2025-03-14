import 'dart:typed_data';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3TonNetwork {
  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// Ton20 代币余额, 类似 brc20, 基于 oridinal 协议，不是 erc20 协议
  /// [address] 钱包地址
  /// [ticker] 代币标识
  /// return 余额
  Future<BigInt> getTon20Balance({required String address, required String ticker});

  /// Jetton token 代币余额, 类似 erc20 协议
  /// [address] 钱包地址
  /// [tokenAddress] 代币地址
  /// return 余额
  Future<BigInt> getJettonTokenBalance({required String address, required String tokenAddress});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [memo] 备注
  /// return 交易 [ABWeb3TonTransaction]
  Future<ABWeb3TonTransaction> buildTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    String? memo,
  });

  /// 构建 Jetton Token 代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [tokenAddress] 代币合约地址
  /// [memo] 备注
  /// return 交易 [ABWeb3TonTransaction]
  Future<ABWeb3TonTransaction> buildJettonTokenTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String tokenAddress,
    String? memo,
  });

  /// 构建 Jetton Token 代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [ticker] 代币标识
  /// [memo] ton20 备注
  /// return 交易 [ABWeb3TonTransaction]
  Future<ABWeb3TonTransaction> buildTon20TransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String ticker,
    String? memo,
  });

  /// 构建合约交易
  /// [rawTx] 交易数据
  /// return 交易 [ABWeb3TonTransaction]
  Future<ABWeb3TonTransaction> buildContractTx({
    required String from,
    required String contract,
    required BigInt value,
    required Uint8List body,
    required int? sendModes,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3TonTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3TonSignedTransaction> signTx({required ABWeb3TonTransaction tx, required ABWeb3Signer signer});

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3TonSentTransaction> sendTx({required ABWeb3TonSignedTransaction tx});
}

/// Ton 交易
abstract class ABWeb3TonTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  String? get tokenAddress;

  String? get memo;

  String? get ticker;

  ABWeb3TonTransactionType get type;
}

enum ABWeb3TonTransactionType { mainTokenTransfer, jettonTokenTransfer, ton20Transfer, contractTransfer }

/// Ton 签名后的交易
abstract class ABWeb3TonSignedTransaction extends ABWeb3SignedTransaction {
  String get signedRaw;
  String get from;
}

/// Ton 已发送的交易
abstract class ABWeb3TonSentTransaction extends ABWeb3SentTransaction {
  String get hash;
}
