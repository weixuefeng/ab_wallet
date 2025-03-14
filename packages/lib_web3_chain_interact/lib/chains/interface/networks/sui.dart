import 'dart:typed_data';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3SuiNetwork {
  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// Sui其他资产 代币余额,
  /// [address] 钱包地址
  /// [tokenAddress] 代币标识,
  /// return 余额
  Future<BigInt> getTokenBalance({required String address, required String tokenAddress});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3SuiTransaction]
  Future<ABWeb3SuiTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 构建 JetSui Token 代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [tokenAddress] 代币合约地址
  /// return 交易 [ABWeb3SuiTransaction]
  Future<ABWeb3SuiTransaction> buildTokenTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String tokenAddress,
  });

  /// 构建合约交易
  /// [data] 交易数据
  /// [gas] gas
  /// return 交易 [ABWeb3SuiTransaction]
  Future<ABWeb3SuiTransaction> buildContractTx({required Uint8List data, required BigInt gas});

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3SuiTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3SuiSignedTransaction> signTx({required ABWeb3SuiTransaction tx, required ABWeb3Signer signer});

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3SuiSentTransaction> sendTx({required ABWeb3SuiSignedTransaction tx});
}

/// Sui 交易
abstract class ABWeb3SuiTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  String? get tokenAddress;
}

/// Sui 签名后的交易
abstract class ABWeb3SuiSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;

  String get txBytes;
}

/// Sui 已发送的交易
abstract class ABWeb3SuiSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}
