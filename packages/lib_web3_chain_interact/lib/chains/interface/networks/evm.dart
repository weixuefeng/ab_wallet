import 'dart:typed_data';
import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_web3_chain_interact/base/i_ab_web3_core_module.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_unsigned_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3EVMNetwork {
  final ABChainInfo mChainInfo;

  factory ABWeb3EVMNetwork(ABChainInfo chainInfo) => ABWeb3CoreModule.instance.getWeb3Network(chainInfo: chainInfo);

  const ABWeb3EVMNetwork.internal(this.mChainInfo);

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
  Future<BigInt> getErc20TokenBalance({required String address, required String tokenAddress});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3EVMTransaction]
  Future<ABWeb3EVMTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 构建ERC20代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [tokenAddress] 代币合约地址
  /// return 交易 [ABWeb3EVMTransaction]
  Future<ABWeb3EVMTransaction> buildErc20TokenTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String tokenAddress,
  });

  /// 构建blob20转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [sidecar] 4844交易的sidecar内容，目前仅来自dapp
  /// return 交易 [ABWeb3EVMTransaction]
  Future<ABWeb3EVMTransaction> buildEIP4844Tx({
    required String from,
    required String to,
    required BigInt amount,
    required Sidecar sidecar,
  });

  /// 构建合约交易
  /// [from] 发送地址
  /// [contractAddress] 合约地址
  /// [data] 数据
  /// [value] 主代币数量
  /// [isEnablingEIP1559] 是否启用EIP1559
  /// return 交易 [ABWeb3EVMTransaction]
  Future<ABWeb3EVMTransaction> buildContractTx({
    required String from,
    required String contractAddress,
    required Uint8List data,
    required BigInt value,
    bool? isEnablingEIP1559,
  });

  /// 构建授权交易
  /// [owner] 发送地址
  /// [spender] 授权地址
  /// [tokenAddress] 合约地址
  /// [amount] 数量
  /// [isEnablingEIP1559] 是否启用EIP1559
  /// return 交易 [ABWeb3EVMTransaction]
  Future<ABWeb3EVMTransaction> buildApproveTx({
    required String owner,
    required String spender,
    required String tokenAddress,
    required BigInt? amount,
    bool? isEnablingEIP1559,
  });

  /// 查询授权额度
  /// [owner] 发送地址
  /// [spender] 授权地址
  /// [tokenAddress] 合约地址
  /// return 数量
  Future<BigInt> allowance({required String owner, required String spender, required String tokenAddress});

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3EVMTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3EVMSignedTransaction> signTx({required ABWeb3EVMTransaction tx, required ABWeb3Signer signer});

  /// 构建未签名交易
  /// [txs] 交易列表
  /// return 签名后的交易列表
  Future<ABWeb3EVMUnsignedTransaction> buildUnsignedTx({required ABWeb3EVMTransaction tx});

  /// 签名多笔交易
  /// [txs] 交易列表
  /// return 签名后的交易列表
  Future<List<ABWeb3EVMSignedTransaction>> signTxs({
    required List<ABWeb3EVMTransaction> txs,
    required ABWeb3Signer signer,
  });

  /// 广播多笔交易
  /// [txs] 交易列表
  /// return 已发送的交易列表
  Future<List<ABWeb3EVMSentTransaction>> sendTxs({required List<ABWeb3EVMSignedTransaction> txs});

  /// 获取L1Gas， 目前只有 OP，OPBNB， MORPH 有
  /// [tx] data 数据
  /// [chainKey]
  /// return L1 gas 费用
  Future<BigInt> getL1Gas({required Uint8List tx, required String chainKey});
}

/// EVM 交易
abstract class ABWeb3EVMTransaction extends ABWeb3Transaction {
  String get from;

  String get to;

  BigInt get value;

  Uint8List? get data;

  BigInt? get gasLimit;

  BigInt? get gasPrice;

  BigInt? get maxFeePerGas;

  BigInt? get maxPriorityFeePerGas;

  /// eip4844 交易需要的手续费
  BigInt? get maxFeePerBlobGas;

  /// eip4844 交易需要的数据
  Sidecar? get sidecar;

  /// 如果evm链存在 l1GasFee，则需要该值, 目前有 OPT，OPBNB, MORPH，需要
  String? get l1GasContract;

  void setGasPrice(BigInt gasPrice);

  void setGasLimit(BigInt gasLimit);

  void setMaxFeePerGas(BigInt maxFeePerGas);

  void setMaxPriorityFeePerGas(BigInt maxPriorityFeePerGas);

  void setMaxFeePerBlobGas(BigInt maxFeePerBlobGas);

  @override
  String toString() {
    return {
      "from": from,
      "to": to,
      "value": value.toString(),
      "data": data,
      "gasLimit": gasLimit,
      "gasPrice": gasPrice,
      "maxFeePerGas": maxFeePerGas,
      "maxPriorityFeePerGas": maxPriorityFeePerGas,
      "maxFeePerBlobGas": maxFeePerBlobGas,
      "sidecar": sidecar,
    }.toString();
  }
}

/// EVM 签名后的交易
abstract class ABWeb3EVMSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// EVM 未签名的交易
abstract class ABWeb3EVMUnsignedTransaction extends ABWeb3UnsignedTransaction {}

/// EVM 已发送的交易
abstract class ABWeb3EVMSentTransaction extends ABWeb3SentTransaction {
  @override
  String get hash;
}

class Sidecar {
  List<Uint8List> bolbs;
  List<Uint8List> commitments;
  List<Uint8List> proofs;

  Sidecar({required this.bolbs, required this.commitments, required this.proofs});
}
