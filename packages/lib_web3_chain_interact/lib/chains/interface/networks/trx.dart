import 'dart:typed_data';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3TrxNetwork {
  const ABWeb3TrxNetwork.internal();

  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// Trx其他资产 代币余额,
  /// [address] 钱包地址
  /// [tokenAddress] 代币标识,
  /// return 余额
  Future<BigInt> getTokenBalance({required String address, required String tokenAddress});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3TrxTransaction]
  Future<ABWeb3TrxTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 构建 JetTrx Token 代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [tokenAddress] 代币合约地址
  /// return 交易 [ABWeb3TrxTransaction]
  Future<ABWeb3TrxTransaction> buildTokenTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String tokenAddress,
  });

  /// 构建合约交易
  /// [from] 发送地址
  /// [contractAddress] 合约地址
  /// [data] 交易数据
  /// [value]
  /// [energyUsed] 能量消耗
  /// return 交易 [ABWeb3TrxTransaction]
  Future<ABWeb3TrxTransaction> buildContractTx({
    required String from,
    required String contractAddress,
    required Uint8List data,
    required BigInt value,
    required int? energyUsed,
  });

  /// 代币授权额度
  /// [owner] 拥有者地址
  /// [spender] 授权地址
  /// [tokenAddress] 代币合约地址
  Future<BigInt> allowance({required String owner, required String spender, required String tokenAddress});

  /// 构建合约交易
  /// [from] 发送地址
  /// [spender] 授权地址
  /// [tokenAddress] 代币合约地址
  /// [amount] 授权数量，默认无限制
  /// return 交易 [ABWeb3TrxTransaction]
  Future<ABWeb3TrxTransaction> buildApproveTx({
    required String from,
    required String spender,
    required String tokenAddress,
    BigInt? amount,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3TrxTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3TrxSignedTransaction> signTx({required ABWeb3TrxTransaction tx, required ABWeb3Signer signer});

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3TrxSentTransaction> sendTx({required ABWeb3TrxSignedTransaction tx});

  /// 签名多笔交易
  /// [txs] 交易列表
  /// return 签名后的交易列表
  Future<List<ABWeb3TrxSignedTransaction>> signTxs({
    required List<ABWeb3TrxTransaction> txs,
    required ABWeb3Signer signer,
  });

  /// 广播多笔交易
  /// [txs] 交易列表
  /// return 已发送的交易列表
  Future<List<ABWeb3TrxSentTransaction>> sendTxs({required List<ABWeb3TrxSignedTransaction> txs});
}

/// Trx 交易
abstract class ABWeb3TrxTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  String? get tokenAddress;

  Uint8List? get data;
}

/// Trx 签名后的交易
abstract class ABWeb3TrxSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// Trx 已发送的交易
abstract class ABWeb3TrxSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}
