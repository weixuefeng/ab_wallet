import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3NearNetwork {
  const ABWeb3NearNetwork();

  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3NearNetwork]
  Future<ABWeb3NearTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [tokenAddress] contractId 合约ID
  /// [amount] 数量
  /// return 交易 [ABWeb3NearNetwork]
  Future<ABWeb3NearTransaction> buildTokenTransferTx({
    required String from,
    required String to,
    required String tokenAddress,
    required BigInt amount,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3NearTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3NearSignedTransaction> signTx({required ABWeb3NearTransaction tx, required ABWeb3KeypairSigner signer});

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3NearSentTransaction> sendTx({required ABWeb3NearSignedTransaction tx});
}

/// Near 交易
abstract class ABWeb3NearTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  String? get tokenAddress;
}

/// Near 签名后的交易
abstract class ABWeb3NearSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// Near 已发送的交易
abstract class ABWeb3NearSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}
