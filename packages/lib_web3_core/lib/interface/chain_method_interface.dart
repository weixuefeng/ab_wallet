import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:lib_web3_core/impl/chain_method_impl.dart';
import 'package:lib_web3_core/interaction/signer/signer.dart';
import 'package:lib_web3_core/interaction/transaction/transaction.dart';
import 'package:lib_web3_core/interaction/txoptions/tx_option.dart';


typedef ABWeb3NetworkId = int;

abstract class ABWeb3Chain<
  Tx extends ABWeb3Transaction,
  SignedTx extends ABWeb3SignedTransaction,
  SentTx extends ABWeb3SentTransaction
> {
  /// 获取区块链网络实例
  static ABWeb3Chain<ABWeb3Transaction, ABWeb3SignedTransaction, ABWeb3SentTransaction> factory(ABWeb3NetworkId networkId) =>
      ABWeb3ChainFactory.create(networkId);

  final ABWeb3NetworkId networkId;

  const ABWeb3Chain.internal(this.networkId);

  /// 是否为EVM网络
  // bool get isEVMNetwork => ABWeb3CoreModule.instance.isEVMNetwork(chainId: chainId);

  /// 主代币symbol
  Future<String> get symbol;

  /// 网络名称
  Future<String> get name;

  /// 主代币余额
  Future<Decimal> balance({required String address});

  /// 代币余额
  Future<Decimal> tokenBalance({
    required String address,
    required String tokenAddress,
  });

  /// 预估手续费
  Future<Decimal> estimateGas({required Tx tx});

  /// 主代币转账(构建交易)
  Future<Tx> buildTransferTx({
    required String from,
    required String to,
    required Decimal amount,
  });

  /// 代币转账(构建交易)
  Future<Tx> buildTokenTransferTx({
    required String from,
    required String to,
    required Decimal amount,
    required String tokenAddress,
  });

  /// 合约调用(构建交易)
  /// [from] 发送地址
  /// [contractAddress] 合约地址
  /// [data] 合约数据
  /// [value] 主代币数量
  /// [options] 其它参数
  Future<Tx> buildContractTx({
    String? from,
    String? contractAddress,
    required Uint8List data,
    Decimal? value,
    ABWeb3ChainBuildTxOptions? options,
  });

  /// 签名交易
  Future<List<SignedTx>> signTxs({
    required List<Tx> txs,
    required ABWeb3Signer signer,
  });

  /// 发送交易
  Future<List<SentTx>> sendTxs({required List<SignedTx> signedTxs});

  /// 是否支持授权协议
  bool get isApprovable => this is ABWeb3ChainApprovable;

  /// 转换为授权协议对象
  ABWeb3ChainApprovable? get asApprovable =>
      isApprovable ? this as ABWeb3ChainApprovable : null;
}

abstract mixin class ABWeb3ChainApprovable {
  /// 查询授权额度
  Future<Decimal> allowance({
    required String tokenAddress,
    required String owner,
    required String spender,
  });

  /// 构建代币授权交易
  Future<ABWeb3Transaction> buildApproveTx({
    required String tokenAddress,
    required String owner,
    required String spender,
    Decimal? amount,
  });
}
