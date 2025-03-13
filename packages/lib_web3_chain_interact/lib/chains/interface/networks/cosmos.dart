import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3CosmosNetwork {
  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// 其他代币余额
  /// [address] 钱包地址
  /// [denom] 代币 denom
  /// return 余额
  Future<BigInt> getTokenBalance({required String address, required String denom});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3CosmosTransaction]
  Future<ABWeb3CosmosTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [denom] 代币denom
  /// return 交易 [ABWeb3CosmosTransaction]
  Future<ABWeb3CosmosTransaction> buildTransferTokenTx({
    required String from,
    required String to,
    required BigInt amount,
    required String denom,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3CosmosTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3CosmosSignedTransaction> signTx({
    required ABWeb3CosmosTransaction tx,
    required ABWeb3PrivateKeySigner signer,
  });

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3CosmosSentTransaction> sendTx({required ABWeb3CosmosSignedTransaction tx});
}

/// Cosmos 交易
abstract class ABWeb3CosmosTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  /// 用于计算gas的一致倍率值，double值，链自主设定，比如，一般默认为 1.0，atom 为 0.025， dydx 为 25000000000，由后端配置返回
  double? get minGasPrice => 1.0;

  /// 发送的代币 denom
  String get denom;

  BigInt? get gas;

  BigInt? get fee;

  void setGas(BigInt gas);

  void setFee(BigInt fee);
}

/// Cosmos 签名后的交易
abstract class ABWeb3CosmosSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// Cosmos 已发送的交易
abstract class ABWeb3CosmosSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}
