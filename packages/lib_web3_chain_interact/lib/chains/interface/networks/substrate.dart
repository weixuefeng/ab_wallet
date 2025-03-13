import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3SubstrateNetwork {
  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// 获取账户最小活跃账户余额，即保持账户开立所需的最低金额
  /// return 最低金额
  Future<BigInt> getMinBalance();

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3SubstrateTransaction]
  Future<ABWeb3SubstrateTransaction> buildTransferTx({
    required String from,
    required String to,
    required BigInt amount,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3SubstrateTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3SubstrateSignedTransaction> signTx({
    required ABWeb3SubstrateTransaction tx,
    required ABWeb3PrivateKeySigner signer,
  });

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3SubstrateSentTransaction> sendTx({required ABWeb3SubstrateSignedTransaction tx});
}

/// Substrate 交易
abstract class ABWeb3SubstrateTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  bool get isEd25519;
}

/// Substrate 签名后的交易
abstract class ABWeb3SubstrateSignedTransaction extends ABWeb3SignedTransaction {
  //
}

/// Substrate 已发送的交易
abstract class ABWeb3SubstrateSentTransaction extends ABWeb3SentTransaction {
  //
}
