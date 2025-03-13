import 'package:lib_web3_chain_interact/chains/interface/ab_web3_sent_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_signed_transaction.dart';
import 'package:lib_web3_chain_interact/chains/interface/ab_web3_transaction.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';

abstract class ABWeb3AptosNetwork {
  /// 网络名称
  Future<String> get name;

  /// 主代币符号
  Future<String> get symbol;

  /// 主代币余额
  /// [address] 钱包地址
  /// return 余额
  Future<BigInt> getBalance({required String address});

  /// Aptos其他资产 代币余额,
  /// [address] 钱包地址
  /// [collectionName] 代币标识,
  /// [tokenName] 代币名称
  /// return 余额
  Future<BigInt> getTokenBalance({required String address, required String collectionName, required String tokenName});

  /// 主代币余额
  /// [address] 钱包地址
  /// [coinAddress] coinAddress,eg: eg: 0x1fc2f33ab6b624e3e632ba861b755fd8e61d2c2e6cf8292e415880b4c198224d::apt20::APTS
  /// return 余额
  Future<BigInt> getCoinBalance({required String address, required String coinAddress});

  /// 主代币余额
  /// [address] 钱包地址
  /// [fungibleAssetType] fungibleAssetType,eg:0x2ebb2ccac5e027a87fa0e2e5f656a3a4238d6a48d93ec9b610d570fc0aa0df12
  /// return 余额
  Future<BigInt> getFungibleAssetBalance({required String address, required String fungibleAssetType});

  /// 构建主代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// return 交易 [ABWeb3AptosTransaction]
  Future<ABWeb3AptosTransaction> buildTransferTx({required String from, required String to, required BigInt amount});

  /// 构建FungibleAsset转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [fungibleAssetType] 数量
  /// return 交易 [ABWeb3AptosTransaction]
  Future<ABWeb3AptosTransaction> buildFungibleAssetTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String fungibleAssetType,
  });

  /// 构建 Aptos offer nft交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [collectionCreator] nft 合集创建者
  /// [collectionName] nft 合集名称
  /// [tokenName] nft名称
  /// return 交易 [ABWeb3AptosTransaction]
  Future<ABWeb3AptosTransaction> buildOfferNftTx({
    required String from,
    required String to,
    required String collectionCreator,
    required String collectionName,
    required String tokenName,
  });

  /// 构建 Aptos Token 代币转账交易
  /// [from] 发送地址
  /// [nftSender] nft 的发送地址
  /// [collectionCreator] nft 合集创建者
  /// [collectionName] nft 合集名称
  /// [tokenName] nft名称
  /// return 交易 [ABWeb3AptosTransaction]
  Future<ABWeb3AptosTransaction> buildClaimNftTx({
    required String from,
    required String nftSender,
    required String collectionCreator,
    required String collectionName,
    required String tokenName,
  });

  /// 构建 Aptos Token 代币转账交易
  /// [from] 发送地址
  /// [to] 接收地址
  /// [amount] 数量
  /// [coinAddress] 代币合约地址,eg: 0x1fc2f33ab6b624e3e632ba861b755fd8e61d2c2e6cf8292e415880b4c198224d::apt20::APTS
  /// return 交易 [ABWeb3AptosTransaction]
  Future<ABWeb3AptosTransaction> buildCoinTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String coinAddress,
  });

  /// 估算交易手续费
  /// [tx] 交易
  /// return 手续费
  Future<BigInt> estimateGas({required ABWeb3AptosTransaction tx});

  /// 签名交易
  /// [tx] 交易
  /// return 签名后的交易
  Future<ABWeb3AptosSignedTransaction> signTx({
    required ABWeb3AptosTransaction tx,
    required ABWeb3KeypairSigner signer,
  });

  /// 广播多笔交易
  /// [tx] 交易列表
  /// return 已发送的交易列表
  Future<ABWeb3AptosSentTransaction> sendTx({required ABWeb3AptosSignedTransaction tx});
}

/// Aptos 交易
abstract class ABWeb3AptosTransaction extends ABWeb3Transaction {
  String get publicKey;

  String get from;

  String? get to;

  BigInt? get value;

  String? get tokenAddress;

  String? get coinAddress;

  String? get collectionCreator;

  String? get collectionName;

  String? get tokenName;

  String? get nftSenderAddress;

  int? get gasPrice;

  int? get maxGasUsed;

  int? get gasUsed;

  String? get fungibleAssetType;

  void setGasPrice(int gasPrice);
}

/// Aptos 签名后的交易
abstract class ABWeb3AptosSignedTransaction extends ABWeb3SignedTransaction {
  @override
  String get signedRaw;
}

/// Aptos 已发送的交易
abstract class ABWeb3AptosSentTransaction extends ABWeb3SentTransaction {
  String get hash;
}
