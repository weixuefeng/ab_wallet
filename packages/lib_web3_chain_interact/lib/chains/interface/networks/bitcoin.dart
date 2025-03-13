import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/chains/model/brc20_balance.dart';
import 'package:lib_web3_chain_interact/chains/model/btc_balance.dart';
import 'package:lib_web3_chain_interact/chains/model/inscribe_data.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3BitcoinNetwork {
  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址, 可用余额
  /// return 余额
  Future<BtcBalance> getBalance({required String address});

  /// Bitcoin其 他资产 代币余额,
  /// [address] 钱包地址
  /// [ticker] brc20 代币标识,
  /// return 余额
  Future<Brc20Balance> getBrc20Balance({required String address, required String ticker});

  /// runes 代币余额
  /// [address] 钱包地址
  /// [runesId] 代币表示
  /// return 余额
  Future<BigInt> getRunesBalance({required String address, required String runesId});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3BitcoinTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3BitcoinSignedTransaction> signTx({
    required ABWeb3BitcoinTransaction tx,
    required ABWeb3KeypairSigner signer,
  });

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3BitcoinSentTransaction> sendTx({required ABWeb3BitcoinSignedTransaction tx});

  /// ------------------------------- oridinals protocol ----------------------------------
  /// 构建铭刻交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [inscribeDatas] 铭刻内容列表
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildInscribeTx({
    required String from,
    required String revealAddress,
    required List<InscribeData> inscribeDatas,
  });

  /// ------------------------------- brc20 protocol ----------------------------------
  /// 构建铭文 20 转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amounts] 数量列表，根据这个值，获取对应可转的 utxo
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildBrc20TransferTx({
    required String from,
    required String to,
    required List<int> amounts,
    required String ticker,
  });

  /// 构建铭文 20 铭刻交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [amount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildBrc20InscribeTransferTx({
    required String from,
    required String revealAddress,
    required BigInt amount,
    required String ticker,
  });

  /// 构建铭文 20 部署交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [supplyAmount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildBrc20InscribeDeployTx({
    required String from,
    required String revealAddress,
    required BigInt supplyAmount,
    required String ticker,
  });

  /// ------------------------------- brc 100 protocol ----------------------------------
  /// 构建铭文 20 转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amounts] 数量列表，根据这个值，获取对应可转的 utxo
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildBrc100TransferTx({
    required String from,
    required String to,
    required List<int> amounts,
    required String ticker,
  });

  /// 构建铭文 20 铭刻交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [amount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildBrc100InscribeTransferTx({
    required String from,
    required String revealAddress,
    required BigInt amount,
    required String ticker,
  });

  /// 构建铭文 20 部署交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [supplyAmount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildBrc100InscribeDeployTx({
    required String from,
    required String revealAddress,
    required BigInt supplyAmount,
    required String ticker,
  });

  /// ------------------------------- drc 100 protocol for doge ----------------------------------
  /// 构建铭文 20 转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amounts] 数量列表，根据这个值，获取对应可转的 utxo
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildDrc20TransferTx({
    required String from,
    required String to,
    required List<int> amounts,
    required String ticker,
  });

  /// 构建铭文 20 铭刻交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [amount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildDrc20InscribeTransferTx({
    required String from,
    required String revealAddress,
    required BigInt amount,
    required String ticker,
  });

  /// 构建铭文 20 部署交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [supplyAmount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildDrc20InscribeDeployTx({
    required String from,
    required String revealAddress,
    required BigInt supplyAmount,
    required String ticker,
  });

  /// ------------------------------- ltc 20 protocol for doge ----------------------------------
  /// 构建铭文 20 转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amounts] 数量列表，根据这个值，获取对应可转的 utxo
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildLtc20TransferTx({
    required String from,
    required String to,
    required List<int> amounts,
    required String ticker,
  });

  /// 构建铭文 20 铭刻交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [amount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildLtc20InscribeTransferTx({
    required String from,
    required String revealAddress,
    required BigInt amount,
    required String ticker,
  });

  /// 构建铭文 20 部署交易
  /// [from] 发送地址
  /// [revealAddress] 揭示地址，在铭刻过程中，一般 from = revealAddress
  /// [supplyAmount] 数量
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildLtc20InscribeDeployTx({
    required String from,
    required String revealAddress,
    required BigInt supplyAmount,
    required String ticker,
  });

  /// ------------------------------- runes protocol for btc ----------------------------------
  /// 构建 符文 转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量列表，根据这个值，获取对应可转的 utxo
  /// return 交易 [ABWeb3BitcoinTransaction]
  Future<ABWeb3BitcoinTransaction> buildRunesTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String runesId,
  });
}

/// Bitcoin 交易
abstract class ABWeb3BitcoinTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt? get value;

  int? get feeRate;

  void setFeeRate(int feeRate);
}

/// Bitcoin 签名后的交易
abstract class ABWeb3BitcoinSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// Bitcoin 已发送的交易
abstract class ABWeb3BitcoinSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}

/// Bitcoin 签名后的交易
abstract class ABWeb3BitcoinOrdinalsSignedTransaction extends ABWeb3BitcoinSignedTransaction {
  List<String> get revealRawTxs;
}

/// Bitcoin 已发送的交易
abstract class ABWeb3BitcoinOridinalsSentTransaction extends ABWeb3BitcoinSentTransaction {
  List<String> get revealHashes;
}
