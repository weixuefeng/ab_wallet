import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3BeaconBnbNetwork {
  const ABWeb3BeaconBnbNetwork();

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
  /// [memo] 备注
  /// return 交易 [ABWeb3BeaconBnbNetwork]
  Future<ABWeb3BeaconBnbTransaction> buildTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    String? memo,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3BeaconBnbTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3BeaconBnbSignedTransaction> signTx({
    required ABWeb3BeaconBnbTransaction tx,
    required ABWeb3PrivateKeySigner signer,
  });

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3BeaconBnbSentTransaction> sendTx({required ABWeb3BeaconBnbSignedTransaction tx});
}

/// BeaconBnb 交易
abstract class ABWeb3BeaconBnbTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  String? get memo;
}

/// BeaconBnb 签名后的交易
abstract class ABWeb3BeaconBnbSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// BeaconBnb 已发送的交易
abstract class ABWeb3BeaconBnbSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}
