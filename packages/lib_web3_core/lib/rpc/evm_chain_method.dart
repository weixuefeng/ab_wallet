import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/protobuf/Ethereum.pb.dart' as Ethereum;
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:http/http.dart';
import 'package:lib_base/logger/ab_logger.dart';
import 'package:lib_web3_core/ens/ens_lookup.dart';
import 'package:lib_web3_core/model/eip1559_fee_model.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';
import 'package:typed_data/typed_data.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/utils/rlp.dart' as rlp;
import 'package:web3dart/src/utils/typed_data.dart';
import 'package:web3dart/web3dart.dart';

enum HardwareWalletType { ledger, gate }

/// 某些特殊的链需要额外增加L1的手续费， 最后一位需要小写，否则 sdk解析校验会失败
const opL1GasContract = "0x420000000000000000000000000000000000000f";
const morphL1GasContract = "0x530000000000000000000000000000000000000f";

class EVMChainMethod {
  final _mHttpClient = Client();

  late final Web3Client mWeb3Client;
  late final EnsLookup mEns;

  EVMChainMethod(String url) {
    mWeb3Client = Web3Client(url, _mHttpClient);
    mEns = EnsLookup.create(mWeb3Client);
  }

  Future<String?> resolveName(String domain) async {
    return mEns.resolveName(domain);
  }

  Future<BigInt> estimateGasV2({
    required String fromAddress,
    required String toAddress,
    BigInt? value,
    BigInt? amountOfGas,
    BigInt? gasPrice,
    BigInt? maxPriorityFeePerGas,
    BigInt? maxFeePerGas,
    Uint8List? data,
  }) async {
    final from = EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(fromAddress));
    final to = EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(toAddress));

    EtherAmount? valueAmount;
    if (value != null) {
      valueAmount = EtherAmount.fromBigInt(EtherUnit.wei, value);
    }

    EtherAmount? gasPriceAmount;

    if (gasPrice != null) {
      gasPriceAmount = EtherAmount.fromBigInt(EtherUnit.wei, gasPrice);
    }

    EtherAmount? maxPriorityFeePerGasAmount;

    if (maxPriorityFeePerGas != null) {
      maxPriorityFeePerGasAmount = EtherAmount.fromBigInt(EtherUnit.wei, maxPriorityFeePerGas);
    }
    EtherAmount? maxFeePerGasAmount;

    if (maxFeePerGas != null) {
      maxFeePerGasAmount = EtherAmount.fromBigInt(EtherUnit.wei, maxFeePerGas);
    }

    final limit = await mWeb3Client.estimateGas(
      sender: from,
      to: to,
      value: valueAmount,
      amountOfGas: amountOfGas,
      gasPrice: gasPriceAmount,
      maxPriorityFeePerGas: maxPriorityFeePerGasAmount,
      maxFeePerGas: maxFeePerGasAmount,
      data: data,
    );
    return limit;
    // 有需要再打开，充分测试
    // return limit * BigInt.from(12) ~/ BigInt.from(10);
  }

  Future<BigInt> estimateGas({
    String? fromAddress,
    String? toAddress,
    EtherAmount? value,
    BigInt? amountOfGas,
    EtherAmount? gasPrice,
    EtherAmount? maxPriorityFeePerGas,
    EtherAmount? maxFeePerGas,
    Uint8List? data,
  }) {
    EthereumAddress? sender;
    if (fromAddress != null) {
      sender = EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(fromAddress));
    }
    EthereumAddress? to;
    if (toAddress != null) {
      to = EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(toAddress));
    }
    return mWeb3Client.estimateGas(
      sender: sender,
      to: to,
      value: value,
      amountOfGas: amountOfGas,
      gasPrice: gasPrice,
      maxPriorityFeePerGas: maxPriorityFeePerGas,
      maxFeePerGas: maxFeePerGas,
      data: data,
    );
  }

  Future<BigInt> gasPrice() {
    return mWeb3Client.getGasPrice().then((value) => value.getValueInUnitBI(EtherUnit.wei));
  }

  // 获取 eip1559 baseFee, 快中慢优先级fee，对应的最大 fee
  Future<List<Eip1559Fee>> getGasInEip1559() async {
    final List<Eip1559Fee> result = [];
    List<double> rewardPercentiles = [25, 50, 70];
    var history = await mWeb3Client.getFeeHistory(10, rewardPercentiles: rewardPercentiles);
    var lastBlock = await mWeb3Client.getBlockInformation();
    var baseFee = lastBlock.baseFeePerGas!.getInWei;
    for (int index = 0; index < rewardPercentiles.length; index++) {
      final List<BigInt> allPriorityFee =
          history['reward']!.map<BigInt>((e) {
            if (e is List && e.isEmpty) {
              //  "reward": [
              //             [],
              //             [
              //                 "0x174876e800",
              //                 "0x174876e800",
              //                 "0x174876e800"
              //             ],
              //             [
              //                 "0x174876e800",
              //                 "0x174876e800",
              //                 "0x174876e800"
              //             ],
              //             [],
              //             []
              //         ],
              // 有可能会返回以上值，特殊处理
              return BigInt.zero;
            }
            return e[index] as BigInt;
          }).toList();
      final priorityFee = allPriorityFee.reduce((curr, next) => curr > next ? curr : next);
      final estimatedGas = BigInt.from(baseFee.toDouble() + priorityFee.toDouble());
      final maxFee = BigInt.from(1.5 * estimatedGas.toDouble());
      result.add(
        Eip1559Fee(
          maxPriorityFeePerGas: priorityFee,
          maxFeePerGas: maxFee,
          estimatedGas: estimatedGas,
          baseFee: baseFee,
        ),
      );
    }
    return result;
  }

  // 获取 eip1559 baseFee, 快中慢优先级fee，对应的最大 fee
  Future<List<Eip1559Fee>> getGasInEip1559V2() async {
    final List<Eip1559Fee> result = [];
    List<double> rewardPercentiles = [25, 50, 70];
    var history = await mWeb3Client.getFeeHistory(10, rewardPercentiles: rewardPercentiles);
    var lastBlock = await mWeb3Client.getBlockInformation();
    var baseFee = lastBlock.baseFeePerGas!.getInWei;
    for (int index = 0; index < rewardPercentiles.length; index++) {
      final List<BigInt> allPriorityFee =
          history['reward']!.map<BigInt>((e) {
            if (e is List && e.isEmpty) {
              //  "reward": [
              //             [],
              //             [
              //                 "0x174876e800",
              //                 "0x174876e800",
              //                 "0x174876e800"
              //             ],
              //             [
              //                 "0x174876e800",
              //                 "0x174876e800",
              //                 "0x174876e800"
              //             ],
              //             [],
              //             []
              //         ],
              // 有可能会返回以上值，特殊处理
              return BigInt.zero;
            }
            return e[index] as BigInt;
          }).toList();
      final priorityFee = allPriorityFee.reduce((curr, next) => curr < next ? curr : next);
      final estimatedGas = BigInt.from(baseFee.toDouble() + priorityFee.toDouble());
      final maxFee = BigInt.from(1.5 * estimatedGas.toDouble());
      result.add(
        Eip1559Fee(
          maxPriorityFeePerGas: priorityFee,
          maxFeePerGas: maxFee,
          estimatedGas: estimatedGas,
          baseFee: baseFee,
        ),
      );
    }
    return result;
  }

  Future<bool?> getTransactionReceiptStatus(String txid) {
    return mWeb3Client.getTransactionReceipt(txid).then((value) => value?.status);
  }

  Future<String> callRaw(String? from, String to, String? data) {
    return mWeb3Client
        .callRaw(
          sender: from == null ? null : EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(from)),
          contract: EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(to)),
          data: data == null ? Uint8List(0) : data.toUint8List(),
        )
        .then((value) => value);
  }

  /// get coin balance
  /// [walletAddress] wallet address
  Future<BigInt> getBalance(String walletAddress) async {
    return mWeb3Client
        .getBalance(EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(walletAddress)))
        .then((value) => value.getValueInUnitBI(EtherUnit.wei));
  }

  /// get transaction count: nonce
  /// [address] wallet Address
  Future<int> getTransactionCount(String address) {
    return mWeb3Client.getTransactionCount(
      EthereumAddress.fromHex(WalletMethodUtils.newAddressToHex(address)),

      /// 目前加速交易并未真正的执行加速， 所以默认pending， 不会影响目前业务
      /// 默认使用 pending， 避免用户高频交易遇到的nonce不正确问题
      // atBlock: const BlockNum.pending(),

      /// Pending 会出现以下问题：Send Failed: transaction would cause overdraft
      /// 改回使用 current
      atBlock: const BlockNum.current(),
    );
  }

  /// send signed transaction
  /// [signedTransaction] after call [signEVMTransaction] get the signed transaction,
  /// you can call sendRawTransaction to boradcast to rpc node.
  Future<String> sendRawTransaction(Uint8List signedTransaction) {
    return mWeb3Client.sendRawTransaction(signedTransaction);
  }

  /// get evm chain id
  Future<int> getNetworkId() {
    return mWeb3Client.getNetworkId();
  }

  /// sign evm transaction
  /// [chainId] evm chain id, eg: eth is 60 ..
  /// [nonce] from address's transaction count
  /// [gasPrice] gas price
  /// [gasLimit] gas limit
  /// [ethAmount] send normal transaction, eth amount is 1, 1.2..., send contract transaction, eth amount maybe 0.
  /// [maxFeePerGas] baseFee + maxPriorityFeePerGas
  /// [maxPriorityFeePerGas] tip fee, [EIP1559](https://docs.alchemy.com/docs/eip-1559)
  /// [privateKeyHex] which is from address' private key hex string.
  /// [data] comment data or contract encoded data.
  String signEVMTransaction(
    int chainId,
    int nonce,
    BigInt gasPrice,
    BigInt gasLimit,
    BigInt ethAmount,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
    String? toAddress,
    String privateKeyHex,
    Uint8List? data,
    int coinType, {
    Ethereum.TransactionMode mode = Ethereum.TransactionMode.Legacy,
  }) {
    if (!privateKeyHex.isHex()) {
      throw Exception('code: 500001, msg: sign transaction error');
    }
    var txMode = coinType == TWCoinTypeExtension.TWCoinTypeFilecoinEVMChain ? Ethereum.TransactionMode.Enveloped : mode;
    bool useNist256p1 = false;
    if (coinType == TWCoinTypeExtension.TWCoinTypeNewChainDevnet ||
        coinType == TWCoinTypeExtension.TWCoinTypeNewChainTestnet ||
        coinType == TWCoinType.TWCoinTypeNewChain) {
      useNist256p1 = true;
      if (toAddress != null) {
        toAddress = WalletMethodUtils.newAddressToHex(toAddress);
      }
    }
    Ethereum.SigningInput input = Ethereum.SigningInput(
      chainId: chainId.toUint8List(),
      txMode: txMode,
      nonce: nonce.toUint8List(),
      gasPrice: gasPrice.toUint8List(),
      gasLimit: gasLimit.toUint8List(),
      maxFeePerGas: maxFeePerGas?.toUint8List(),
      maxInclusionFeePerGas: maxPriorityFeePerGas?.toUint8List(),
      toAddress: toAddress,
      useNist256p1Sign: useNist256p1,
      privateKey: privateKeyHex.toUint8List(),
      transaction: Ethereum.Transaction(
        transfer: Ethereum.Transaction_Transfer(
          amount: EtherAmount.fromBigInt(EtherUnit.wei, ethAmount).getValueInUnitBI(EtherUnit.wei).toUint8List(),
          data: data,
        ),
      ),
    );
    final output = Ethereum.SigningOutput.fromBuffer(
      AnySigner.sign(
        input.writeToBuffer(),
        coinType == TWCoinTypeExtension.TWCoinTypeFilecoinEVMChain ? TWCoinType.TWCoinTypeEthereum : coinType,
      ).toList(),
    );
    return hex.encode(output.encoded.toList());
  }

  Uint8List getEVMUnSignedTransaction(HardwareWalletType type, int chainId, Transaction transaction) {
    if (transaction.isEIP1559 && chainId != null) {
      final encodedTx = LengthTrackingByte();
      encodedTx.addByte(0x02);
      encodedTx.add(rlp.encode(_encodeEIP1559ToRlp(transaction, null, BigInt.from(chainId))));
      encodedTx.close();
      return encodedTx.asBytes();
    }
    final innerSignature = chainId == null ? null : MsgSignature(BigInt.zero, BigInt.zero, chainId);

    final encoded = uint8ListFromList(rlp.encode(_encodeToRlp(type, chainId, transaction, null)));
    List<int> list = type == HardwareWalletType.gate ? [] : [1];
    list.addAll(encoded);
    var res = Uint8List.fromList(list);
    return res;
  }

  List<dynamic> _encodeEIP1559ToRlp(Transaction transaction, MsgSignature? signature, BigInt chainId) {
    final list = [
      chainId,
      transaction.nonce,
      transaction.maxPriorityFeePerGas!.getInWei,
      transaction.maxFeePerGas!.getInWei,
      transaction.maxGas,
    ];

    if (transaction.to != null) {
      list.add(transaction.to!.addressBytes);
    } else {
      list.add('');
    }

    list
      ..add(transaction.value?.getInWei)
      ..add(transaction.data);

    list.add([]); // access list

    if (signature != null) {
      list
        ..add(signature.v)
        ..add(signature.r)
        ..add(signature.s);
    }

    return list;
  }

  List<dynamic> _encodeToRlp(HardwareWalletType type, int chainId, transaction, MsgSignature? signature) {
    final list =
        type == HardwareWalletType.ledger
            ? [chainId, transaction.nonce, transaction.gasPrice?.getInWei, transaction.maxGas]
            : [transaction.nonce, transaction.gasPrice?.getInWei, transaction.maxGas];

    if (transaction.to != null) {
      list.add(transaction.to!.addressBytes);
    } else {
      list.add('');
    }

    list
      ..add(transaction.value?.getInWei)
      ..add(transaction.data);
    if (type == HardwareWalletType.ledger) {
      list.add([]);
    }

    if (signature != null) {
      list
        ..add(signature.v)
        ..add(signature.r)
        ..add(signature.s);
    } else {
      if (type == HardwareWalletType.gate) {
        list
          ..add(chainId)
          ..add(0)
          ..add(0);
      }
    }

    // log('rlp list: $list');

    return list;
  }

  Transaction generateTransaction(
    int nonce,
    BigInt gasPrice,
    BigInt gasLimit,
    BigInt ethAmount,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
    String? toAddress,
    Uint8List? data,
    int coinType,
  ) {
    var transaction = Transaction(
      to: toAddress == null ? null : EthereumAddress.fromHex(toAddress),
      value: EtherAmount.fromBigInt(EtherUnit.wei, ethAmount),
      data: data ?? Uint8List(0),
      nonce: nonce,
      gasPrice: EtherAmount.fromBigInt(EtherUnit.wei, gasPrice),
      maxFeePerGas: maxFeePerGas == null ? null : EtherAmount.fromBigInt(EtherUnit.wei, maxFeePerGas),
      maxPriorityFeePerGas:
          maxPriorityFeePerGas == null ? null : EtherAmount.fromBigInt(EtherUnit.wei, maxPriorityFeePerGas),
      maxGas: gasLimit.toInt(),
    );
    return transaction;
  }

  // generate broadcat transaction
  String generateBroadcastTransaction(
    HardwareWalletType type,
    int chainId,
    Transaction transaction,
    MsgSignature signature,
  ) {
    var encoded = rlp.encode(_encodeToRlp(type, chainId, transaction, signature));
    List<int> list = type == HardwareWalletType.gate ? [] : [1];
    list.addAll(encoded);
    return uint8ListFromList(list).toHex();
  }

  Future<String?> signAndSendTransaction(
    int chainId,
    String fromAddress,
    String? toAddress,
    BigInt amount,
    Uint8List? data,
    String privateKeyHex,
    int coinType, {
    BigInt? preGasPrice,
    BigInt? preGasLimit,
    bool onlySign = false,
    int? nonce,
  }) async {
    // get nonce
    var _count = nonce ?? await getTransactionCount(fromAddress);
    // get gas price
    var _gasPrice = preGasPrice ?? await gasPrice();
    // estimate gas
    var _gasLimit =
        preGasLimit ??
        await estimateGas(
          fromAddress: fromAddress,
          toAddress: toAddress,
          value: EtherAmount.fromBigInt(EtherUnit.wei, amount),
          data: data,
        );
    // format gas price， only for gate chain
    // if (coinType == TWCoinType.TWCoinTypeGateChain) {
    //   Log.d("gas: $_gasPrice");
    //   var price = BigDecimal.parse(
    //     (_gasPrice! / BigInt.from(10).pow(9)).toString(),
    //   ).toBigInt(roundingMode: RoundingMode.UP);
    //   _gasPrice = price * BigInt.from(10).pow(9);
    //   Log.d("gas2: $_gasPrice");
    // }

    // sign
    var signedTransaction = signEVMTransaction(
      chainId,
      _count,
      _gasPrice!,
      _gasLimit,
      amount,
      _gasPrice,
      _gasPrice,
      toAddress,
      privateKeyHex,
      data,
      coinType,
      // mode: Ethereum.TransactionMode.Enveloped,
    );
    if (onlySign) {
      return signedTransaction;
    }
    return sendRawTransaction(signedTransaction.toUint8List());
  }

  Future<String?> signAndSendTransactionForDApp(
    int chainId,
    String fromAddress,
    String? toAddress,
    BigInt amount,
    Uint8List? data,
    String privateKeyHex,
    int coinType, {
    BigInt? preGasPrice,
    BigInt? preGasLimit,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
    bool onlySign = false,
    int? nonce,
  }) async {
    // get nonce
    var _count = nonce ?? await getTransactionCount(fromAddress);
    // get gas price
    var _gasPrice = preGasPrice ?? await gasPrice();
    // estimate gas
    var _gasLimit =
        preGasLimit ??
        await estimateGas(
          fromAddress: fromAddress,
          toAddress: toAddress,
          value: EtherAmount.fromBigInt(EtherUnit.wei, amount),
          data: data,
        );
    // format gas price， only for gate chain
    // if (coinType == TWCoinType.TWCoinTypeGateChain) {
    //   Log.d("gas: $_gasPrice");
    //   var price = BigDecimal.parse(
    //     (_gasPrice! / BigInt.from(10).pow(9)).toString(),
    //   ).toBigInt(roundingMode: RoundingMode.UP);
    //   _gasPrice = price * BigInt.from(10).pow(9);
    //   Log.d("gas2: $_gasPrice");
    // }

    var isSupport1559 = (maxFeePerGas != null) && (maxPriorityFeePerGas != null);
    // sign
    var signedTransaction = signEVMTransaction(
      chainId,
      _count,
      _gasPrice!,
      _gasLimit,
      amount,
      maxFeePerGas,
      maxPriorityFeePerGas,
      toAddress,
      privateKeyHex,
      data,
      coinType,
      mode: isSupport1559 ? Ethereum.TransactionMode.Enveloped : Ethereum.TransactionMode.Legacy,
    );
    if (onlySign) {
      return signedTransaction;
    }
    return sendRawTransaction(signedTransaction.toUint8List());
  }

  /// 只签名交易，不发送交易广播，后端上链需求专用
  Future<String> onlySignTransaction(
    int chainId,
    String fromAddress,
    String? toAddress,
    BigInt amount,
    Uint8List? data,
    String privateKeyHex,
    int coinType, {
    BigInt? preGasPrice,
    BigInt? preGasLimit,
  }) async {
    // get nonce
    var _count = await getTransactionCount(fromAddress);
    // get gas price
    var _gasPrice = preGasPrice ?? await gasPrice();
    // estimate gas
    var _gasLimit =
        preGasLimit ??
        await estimateGas(
          fromAddress: fromAddress,
          toAddress: toAddress,
          value: EtherAmount.fromBigInt(EtherUnit.wei, amount),
          data: data,
        );
    // format gas price， only for gate chain
    // if (coinType == TWCoinType.TWCoinTypeGateChain) {
    //   Log.d("gas: $_gasPrice");
    //   var price = BigDecimal.parse(
    //     (_gasPrice! / BigInt.from(10).pow(9)).toString(),
    //   ).toBigInt(roundingMode: RoundingMode.UP);
    //   _gasPrice = price * BigInt.from(10).pow(9);
    //   Log.d("gas2: $_gasPrice");
    // }
    // sign
    var signedTransaction = signEVMTransaction(
      chainId,
      _count,
      _gasPrice!,
      _gasLimit,
      amount,
      _gasPrice,
      _gasPrice,
      toAddress,
      privateKeyHex,
      data,
      coinType,
    );
    return signedTransaction;
  }

  /// call send eth for transfer token.
  /// [chainId] evm chain id, eg: eth is 60 ..
  /// [walletAddress] which wallet you will send token, is From address.
  /// [targetAddress] which address you will receive token, is to address.
  /// [amount] transaction token's number.
  /// [privateKeyHex] which is from address' private key hex string.
  Future<String?> sendETH(
    int chainId,
    String walletAddress,
    String targetAddress,
    BigInt amount,
    String privateKeyHex,
    int coinType,
  ) async {
    return signAndSendTransaction(chainId, walletAddress, targetAddress, amount, null, privateKeyHex, coinType);
  }

  /// ERC 20 function
  /// call send token for transfer erc20 token.
  /// [chainId] evm chain id, eg: eth is 60 ..
  /// [contractAddress] evm contraction address
  /// [walletAddress] which wallet you will send token, is From address.
  /// [targetAddress] which address you will receive token, is to address.
  /// [amount] transaction token's number.
  /// [privateKeyHex] which is from address' private key hex string.
  /// todo: have not test.
  Future<String?> sendERC20Token(
    int chainId,
    String contractAddress,
    String walletAddress,
    String targetAddress,
    BigInt amount,
    String privateKeyHex,
    int coinType,
  ) async {
    if (privateKeyHex.toLowerCase().startsWith("0x")) {
      privateKeyHex = privateKeyHex.substring(2);
    }
    var encoded = encodeERC20Transfer(walletAddress, targetAddress, amount);
    return signAndSendTransaction(
      chainId,
      walletAddress,
      contractAddress,
      BigInt.zero,
      encoded,
      privateKeyHex,
      coinType,
    );
  }

  /// encode erc20 transfer
  /// [walletAddress] which wallet you will send token, is From address.
  /// [targetAddress] which address you will receive token, is to address.
  /// [amount] transaction token's number.
  Uint8List encodeERC20Transfer(String walletAddress, String targetAddress, BigInt amount) {
    var function = EthereumAbiFunction.createWithString("transfer");
    function.addParamAddress(targetAddress.toUint8List(), false);
    Uint8List unit8List = amount.toUint8List();
    function.addParamUInt256(unit8List, false);
    var encoded = EthereumAbi.encode(function);
    return encoded;
  }

  /// encode erc20 approve
  /// [spender] which wallet you will approve token, is target address.
  /// [amount] transaction token's number.
  Uint8List encodeERC20Approve(String spender, BigInt amount) {
    var function = EthereumAbiFunction.createWithString("approve");
    function.addParamAddress(spender.toUint8List(), false);
    Uint8List unit8List = amount.toUint8List();
    function.addParamUInt256(unit8List, false);
    var encoded = EthereumAbi.encode(function);
    return encoded;
  }

  Uint8List encodeGetL1Fee(Uint8List tx) {
    var function = EthereumAbiFunction.createWithString("getL1Fee");
    function.addParamBytes(tx, false);
    var encoded = EthereumAbi.encode(function);
    return encoded;
  }

  // for op and morph L1 层手续费, 目前单独处理， 之后跟随 wallet_core重构
  Future<int> getL1Fee(Uint8List tx, {String gasContract = opL1GasContract}) async {
    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(gasContract),
      data: encodeGetL1Fee(tx),
    );
    if (res.toLowerCase().startsWith('0x')) {
      /// 如果是0，morph链返回的16进制是0x，而不是 0x0， 避免转换失败，特殊处理
      String hexValue = res.substring(2);
      if (hexValue.isEmpty) {
        hexValue = '0';
      }
      return int.parse(hexValue, radix: 16);
    }
    return int.parse(res);
  }

  Future<BigInt> getL1FeeV2({required Uint8List dataTx, required String chainKey}) async {
    String gasContract = '';
    switch (chainKey) {
      case 'OPT':
      case 'OPBNB':
        gasContract = opL1GasContract;
        break;
      case 'MORPH':
        gasContract = morphL1GasContract;
        break;

      /// 不支持的链返回0
      default:
        return BigInt.zero;
    }

    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(gasContract),
      data: encodeGetL1Fee(dataTx),
    );
    if (res.toLowerCase().startsWith('0x')) {
      /// 如果是0，morph链返回的16进制是0x，而不是 0x0， 避免转换失败，特殊处理
      String hexValue = res.substring(2);
      if (hexValue.isEmpty) {
        hexValue = '0';
      }
      return BigInt.parse(hexValue, radix: 16);
    }
    return BigInt.parse(res);
  }

  Future<int> getL1GasUsedFee(Uint8List tx, {String gasContract = opL1GasContract}) async {
    var function = EthereumAbiFunction.createWithString("getL1GasUsed");
    function.addParamBytes(tx, false);
    var encoded = EthereumAbi.encode(function);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(gasContract), data: encoded);
    return int.parse(res);
  }

  /// 授权代币数量
  Future<String?> approveToken(
    String contractAddress,
    String walletAddress,
    String spenderAddress,
    BigInt amount,
    int chainId,
    String privateKeyHex,
    int coinType,
  ) async {
    var encoded = encodeERC20Approve(spenderAddress, amount);
    return await signAndSendTransaction(
      chainId,
      walletAddress,
      contractAddress,
      BigInt.zero,
      encoded,
      privateKeyHex,
      coinType,
    );
  }

  /// erc1155 get token balance
  Future<BigInt> getErc1155TokenBalance(String contractAddress, String walletAddress, BigInt tokenId) async {
    var function = EthereumAbiFunction.createWithString("balanceOf");
    function.addParamAddress(walletAddress.toUint8List(), false);
    function.addParamUInt256(tokenId.toUint8List(), false);
    var encoded = EthereumAbi.encode(function);
    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(contractAddress),
      data: encoded,
    );
    if (res == '0x') {
      res = '0x0';
    }
    return BigInt.parse(res);
  }

  /// erc20 get token balance
  /// [contractAddress] token contract address
  /// [walletAddress] wallet address
  /// [Future<BigInt>] balance info
  Future<BigInt> getTokenBalance(String contractAddress, String walletAddress) async {
    List<FunctionParameter> list = [];
    var params = const FunctionParameter("address", AddressType());
    list.add(params);
    var function = ContractFunction("balanceOf", list);
    var parameterList = [EthereumAddress.fromHex(walletAddress)];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractAddress), data: data);
    if (res == '0x') {
      res = '0x0';
    }
    return BigInt.parse(res);
  }

  /// erc20 get token symbol
  /// [contractAddress] input contract address
  Future<String> getTokenSymbol(String contractAddress) async {
    List<FunctionParameter> list = [];
    List<FunctionParameter> outPuts = [];
    var params = const FunctionParameter("symbol", StringType());
    outPuts.add(params);
    var function = ContractFunction("symbol", list, outputs: outPuts);
    var parameterList = [];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractAddress), data: data);
    var result = function.decodeReturnValues(res);
    return result[0];
  }

  /// erc20 get token name
  /// [contractAddress] input contract address
  Future<String> getTokenName(String contractAddress) async {
    List<FunctionParameter> list = [];
    List<FunctionParameter> outPuts = [];
    var params = const FunctionParameter("name", StringType());
    outPuts.add(params);
    var function = ContractFunction("name", list, outputs: outPuts);
    var parameterList = [];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractAddress), data: data);
    var result = function.decodeReturnValues(res);
    return result[0];
  }

  /// erc20 getTokenDecimals
  /// [contractAddress] input contract address
  Future<BigInt> getTokenDecimals(String contractAddress) async {
    List<FunctionParameter> list = [];
    List<FunctionParameter> outPuts = [];
    var params = const FunctionParameter("decimals", IntType());
    outPuts.add(params);
    var function = ContractFunction("decimals", list, outputs: outPuts);
    var parameterList = [];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractAddress), data: data);
    var result = function.decodeReturnValues(res);
    return result[0];
  }

  /// erc20 getTokenDecimals
  /// [contractAddress] input contract address
  Future<BigInt> getTokenTotalSupply(String contractAddress) async {
    List<FunctionParameter> list = [];
    List<FunctionParameter> outPuts = [];
    var params = const FunctionParameter("totalSupply", IntType());
    outPuts.add(params);
    var function = ContractFunction("totalSupply", list, outputs: outPuts);
    var parameterList = [];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractAddress), data: data);
    var result = function.decodeReturnValues(res);
    return result[0];
  }

  /// 获取代币授权数量函数数据
  /// get erc20 allowance number
  /// [owner] which wallet you will send token, is From address.
  /// [spender] which address you will receive token, is to address.
  Uint8List encodeERC20Allowance(String owner, String spender) {
    var function = EthereumAbiFunction.createWithString("allowance");
    function.addParamAddress(owner.toUint8List(), false);
    function.addParamAddress(spender.toUint8List(), false);
    var encoded = EthereumAbi.encode(function);
    return encoded;
  }

  /// 获取代币授权数量
  Future<BigInt> getERC20Allowance(String contractAddress, String owner, String spender) async {
    try {
      var encode = encodeERC20Allowance(owner, spender);
      var res = await mWeb3Client.callRaw(
        sender: null,
        contract: EthereumAddress.fromHex(contractAddress),
        data: encode,
      );
      if (res == '0x') {
        res = '0x0';
      }
      return hexToInt(res);
    } catch (e) {
      ABLogger.e("error: ${e.toString()}");
      return BigInt.zero;
    }
  }

  // gate contract deposit
  Uint8List encodeGateDeposit(String user, BigInt amount) {
    var function = EthereumAbiFunction.createWithString("deposit");
    function.addParamAddress(user.toUint8List(), false);
    function.addParamUInt256(amount.toUint8List(), false);
    var encoded = EthereumAbi.encode(function);
    return encoded;
  }

  /// 充值代币
  Future<String?> depositToken(
    String contractAddress,
    String walletAddress,
    String userAddress,
    BigInt amount,
    int chainId,
    String privateKeyHex,
    int coinType,
  ) async {
    var encoded = encodeGateDeposit(userAddress, amount);
    return await signAndSendTransaction(
      chainId,
      walletAddress,
      contractAddress,
      BigInt.zero,
      encoded,
      privateKeyHex,
      coinType,
    );
  }

  // gate contract withdraw
  Uint8List encodeGateWithdraw(
    BigInt amount,
    BigInt babyPubKey,
    BigInt numExitRoot,
    List<BigInt>? siblings,
    BigInt idx,
  ) {
    List<FunctionParameter> input = [];
    var amountParam = const FunctionParameter("amount", UintType(length: 192));
    var babyPubKeyParam = const FunctionParameter("babyPubKey", UintType(length: 256));
    var numExitRootParam = const FunctionParameter("numExitRoot", UintType(length: 32));
    var siblingsParam = const FunctionParameter("siblings", DynamicLengthArray(type: UintType()));
    var idxParam = const FunctionParameter("idx", UintType(length: 48));
    input.add(amountParam);
    input.add(babyPubKeyParam);
    input.add(numExitRootParam);
    input.add(siblingsParam);
    input.add(idxParam);
    var function = ContractFunction("withdrawMerkleProof", input);
    var parameterList = [amount, babyPubKey, numExitRoot, siblings, idx];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// 提现代币
  ///
  Future<String?> withdrawToken(
    String contractAddress,
    String walletAddress,
    BigInt amout,
    BigInt babyPubKey,
    BigInt numExitRoot,
    List<BigInt>? siblings,
    BigInt idx,
    int chainId,
    String privateKeyHex,
    int coinType,
  ) async {
    var encoded = encodeGateWithdraw(amout, babyPubKey, numExitRoot, siblings, idx);
    return await signAndSendTransaction(
      chainId,
      walletAddress,
      contractAddress,
      BigInt.zero,
      encoded,
      privateKeyHex,
      coinType,
    );
  }

  /// ERC721 functions ----
  /// get erc721 token owner address
  /// [contractAddress] input contract address
  Future<String> getTokenOwner(String contractAddress, BigInt tokenId) async {
    List<FunctionParameter> list = [];
    var params = const FunctionParameter("tokenId", UintType());
    list.add(params);
    List<FunctionParameter> outPuts = [];
    var outPutsParams = const FunctionParameter("ownerAddress", AddressType());
    outPuts.add(outPutsParams);
    var function = ContractFunction("ownerOf", list, outputs: outPuts);
    var parameterList = [tokenId];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractAddress), data: data);
    var result = function.decodeReturnValues(res);
    return result[0].toString();
  }

  /// call send token for transfer erc721 token.
  /// [chainId] evm chain id, eg: eth is 60 ..
  /// [contractAddress] evm contraction address
  /// [walletAddress] which wallet you will send token, is From address.
  /// [targetAddress] which address you will receive token, is to address.
  /// [tokenId] contract tokenId
  /// [privateKeyHex] which is from address' private key hex string.
  Future<String?> sendERC721Token(
    int chainId,
    String contractAddress,
    String walletAddress,
    String targetAddress,
    BigInt tokenId,
    String privateKeyHex,
    int coinType,
  ) async {
    if (privateKeyHex.toLowerCase().startsWith("0x")) {
      privateKeyHex = privateKeyHex.substring(2);
    }
    var encoded = encodeERC721Transfer(walletAddress, targetAddress, tokenId);
    return signAndSendTransaction(
      chainId,
      walletAddress,
      contractAddress,
      BigInt.zero,
      encoded,
      privateKeyHex,
      coinType,
    );
  }

  /// encode erc721 transfer for estimateGas
  /// [walletAddress] which wallet you will send token, is From address.
  /// [targetAddress] which address you will receive token, is to address.
  /// [tokenId] contract tokenId
  Uint8List encodeERC721Transfer(String walletAddress, String targetAddress, BigInt tokenId) {
    var function = EthereumAbiFunction.createWithString("transferFrom");
    function.addParamAddress(walletAddress.toUint8List(), false);
    function.addParamAddress(targetAddress.toUint8List(), false);
    Uint8List unit8List = tokenId.toUint8List();
    function.addParamUInt256(unit8List, false);
    var encoded = EthereumAbi.encode(function);
    return encoded;
  }

  /// encode erc1155 safe transfer from without test
  /// [fromAddress] Source address
  /// [targetAddress] Target address
  /// [tokenId] ID of the token type
  /// [value] Transfer amount
  /// [data] Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
  Uint8List encodeERC1155SafeTransferFrom(
    String fromAddress,
    String targetAddress,
    BigInt tokenId,
    BigInt value,
    Uint8List data,
  ) {
    var function = EthereumAbiFunction.createWithString("safeTransferFrom");
    function.addParamAddress(fromAddress.toUint8List(), false);
    function.addParamAddress(targetAddress.toUint8List(), false);
    function.addParamUInt256(tokenId.toUint8List(), false);
    function.addParamUInt256(value.toUint8List(), false);
    function.addParamBytes(data, false);
    var encoded = EthereumAbi.encode(function);
    return encoded;
  }

  /// call send token for transfer erc1155 token.
  /// [chainId] evm chain id, eg: eth is 60 ..
  /// [contractAddress] evm contraction address
  /// [walletAddress] which wallet you will send token, is From address.
  /// [targetAddress] which address you will receive token, is to address.
  /// [tokenId] contract tokenId
  /// [privateKeyHex] which is from address' private key hex string.
  Future<String?> sendERC1155Token(
    int chainId,
    String contractAddress,
    String walletAddress,
    String targetAddress,
    BigInt tokenId,
    BigInt amount,
    String privateKeyHex,
    int coinType,
  ) async {
    if (privateKeyHex.toLowerCase().startsWith("0x")) {
      privateKeyHex = privateKeyHex.substring(2);
    }
    var encoded = encodeERC1155SafeTransferFrom(walletAddress, targetAddress, tokenId, amount, Uint8List.fromList([0]));
    return signAndSendTransaction(
      chainId,
      walletAddress,
      contractAddress,
      BigInt.zero,
      encoded,
      privateKeyHex,
      coinType,
    );
  }

  /// signTypedMessage v4
  /// [privateKeyHex] private key hex string
  /// [payload] eip172 payload
  /// eg:{"types":{"EIP712Domain":[{"type":"string","name":"name"},{"type":"string","name":"version"},{"type":"uint256","name":"chainId"},{"type":"address","name":"verifyingContract"}],"Part":[{"name":"account","type":"address"},{"name":"value","type":"uint96"}],"Mint721":[{"name":"tokenId","type":"uint256"},{"name":"tokenURI","type":"string"},{"name":"creators","type":"Part[]"},{"name":"royalties","type":"Part[]"}]},"domain":{"name":"Mint721","version":"1","chainId":4,"verifyingContract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce"},"primaryType":"Mint721","message":{"@type":"ERC721","contract":"0x2547760120aed692eb19d22a5d9ccfe0f7872fce","tokenId":"1","uri":"ipfs://ipfs/hash","creators":[{"account":"0xc5eac3488524d577a1495492599e8013b1f91efa","value":10000}],"royalties":[],"tokenURI":"ipfs://ipfs/hash"}}
  static String signTypedMessageV4(String privateKeyHex, String payload) {
    var raw = EthSigUtil.signTypedData(jsonData: payload, version: TypedDataVersion.V4, privateKey: privateKeyHex);
    return raw;
  }

  static String signTypedMessageV4Params(
    String privateKeyHex,
    String primaryType,
    Map<String, dynamic> types,
    Map<String, String> domain,
    Map<String, dynamic> message,
  ) {
    var arrayDomin = [];
    domain.forEach((key, value) {
      var part = getPartByName(key);
      arrayDomin.add(part);
    });
    var typesParam = {};
    typesParam["EIP712Domain"] = arrayDomin;
    types.forEach((key, value) {
      typesParam[key] = value;
    });
    // todo: calculate primary type
    var json = {"types": typesParam, "domain": domain, "primaryType": primaryType, "message": message};
    return signTypedMessageV4(privateKeyHex, jsonEncode(json));
  }

  static dynamic getPartByName(String name) {
    var partName = {"type": "string", "name": "name"};
    var partVersion = {"type": "string", "name": "version"};
    var partAddress = {"type": "address", "name": "verifyingContract"};
    var partChainId = {"type": "uint256", "name": "chainId"};
    var partSalt = {"type": "string", "name": "salt"};
    var map = {
      "name": partName,
      "version": partVersion,
      "verifyingContract": partAddress,
      "chainId": partChainId,
      "salt": partSalt,
    };
    return map[name];
  }

  // sign personal message
  static String signMessage(String privateHex, Uint8List payload) {
    var raw = EthSigUtil.signPersonalMessage(message: payload, privateKey: privateHex);
    return raw;
  }

  /// await get transaction receipt, confirm transaction had boardcast
  /// etherum block time is 15s, check 20s
  Future<bool> awaitTransaction(String txid) async {
    for (var i = 0; i < 20; i++) {
      var status = await getTransactionReceiptStatus(txid);
      if (status == null) {
        sleep(const Duration(seconds: 1));
      } else {
        return status;
      }
    }
    return false;
  }

  /// uniswap v2 ---
  ///  get pair balance information
  /// [pairContractAddress] pair contract address
  /// return [token0 balance, token1 balance]
  Future<List<BigInt>> getReserves(String pairContractAddress) async {
    // get pool information,
    List<FunctionParameter> outPuts = [];
    var reverse0 = const FunctionParameter("_reserve0", UintType(length: 112));
    var reverse1 = const FunctionParameter("_reserve1", UintType(length: 112));
    var blockTimestampLast = const FunctionParameter("_blockTimestampLast", UintType(length: 32));
    outPuts.add(reverse0);
    outPuts.add(reverse1);
    outPuts.add(blockTimestampLast);

    var function = ContractFunction("getReserves", [], outputs: outPuts);

    var parameterList = [];
    var data = function.encodeCall(parameterList);

    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(pairContractAddress),
      data: data,
    );
    var result = function.decodeReturnValues(res);
    var token0 = result[0];
    var token1 = result[1];
    return [BigInt.parse(token0.toString()), BigInt.parse(token1.toString())];
  }

  ///  get pair token0 contract address
  /// [pairContractAddress] pair contract address
  /// return token0 address
  Future<String> getToken0(String pairContractAddress) async {
    List<FunctionParameter> outPuts = [];
    var address = const FunctionParameter("", AddressType());
    outPuts.add(address);
    var function = ContractFunction("token0", [], outputs: outPuts);
    var parameterList = [];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(pairContractAddress),
      data: data,
    );
    var result = function.decodeReturnValues(res);
    var token0Address = result[0];
    return token0Address.toString();
  }

  ///  get pair token1 contract address
  /// [pairContractAddress] pair contract address
  /// return token1 address
  Future<String> getToken1(String pairContractAddress) async {
    List<FunctionParameter> outPuts = [];
    var address = const FunctionParameter("", AddressType());
    outPuts.add(address);
    var function = ContractFunction("token1", [], outputs: outPuts);
    var parameterList = [];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(pairContractAddress),
      data: data,
    );
    var result = function.decodeReturnValues(res);
    var token1Address = result[0];
    return token1Address.toString();
  }

  /// calculate input valud by out value. eg: i want to got 1 eth, how much uni should pay?
  /// you should call this function by:
  /// [routeContractAddress] router contract address
  /// [amountOut] your input value
  /// [routeAddressPair] router address pair, [inputTokenAddress, outputTokenAddress], i know output value.
  Future<String> getAmountsIn(String routeContractAddress, BigInt amountOut, List<String> routeAddressPair) async {
    List<FunctionParameter> inPuts = [];
    var amountOutParams = const FunctionParameter("amountOut", UintType(length: 256));
    var path = const FunctionParameter("path", DynamicLengthArray(type: AddressType()));
    inPuts.add(amountOutParams);
    inPuts.add(path);
    List<FunctionParameter> outPuts = [];
    var amounts = const FunctionParameter("amounts", DynamicLengthArray(type: UintType(length: 256)));
    outPuts.add(amounts);
    var function = ContractFunction("getAmountsIn", inPuts, outputs: outPuts);
    var parameterList = [amountOut, routeAddressPair.map((e) => EthereumAddress.fromHex(e)).toList()];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(routeContractAddress),
      data: data,
    );
    var result = function.decodeReturnValues(res);
    var amount = result[0];
    return amount[0].toString();
  }

  /// calculate out valud by input value. eg: i have 1 eth, how much uni i can got?
  /// you should call this function by:
  /// [routeContractAddress] router contract address
  /// [amountIn] your input value
  /// [routeAddressPair] router address pair, [wethaddress, aaveaddress] ...
  Future<String> getAmountsOut(String routeContractAddress, BigInt amountIn, List<String> routeAddressPair) async {
    List<FunctionParameter> inPuts = [];
    var amountOutParams = const FunctionParameter("amountIn", UintType(length: 256));
    var path = const FunctionParameter("path", DynamicLengthArray(type: AddressType()));
    inPuts.add(amountOutParams);
    inPuts.add(path);
    List<FunctionParameter> outPuts = [];
    var amounts = const FunctionParameter("amounts", DynamicLengthArray(type: UintType(length: 256)));
    outPuts.add(amounts);
    var function = ContractFunction("getAmountsOut", inPuts, outputs: outPuts);
    var parameterList = [amountIn, routeAddressPair.map((e) => EthereumAddress.fromHex(e)).toList()];
    var data = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(routeContractAddress),
      data: data,
    );
    var result = function.decodeReturnValues(res);
    var amount = result[0];
    return amount[1].toString();
  }

  /// encodeSwapETHForExactTokens
  Uint8List encodeSwapETHForExactTokens(BigInt amountOut, List<String> path, String toAddress, BigInt deadline) {
    List<FunctionParameter> input = [];
    var amountOutParams = const FunctionParameter("amountOut", UintType(length: 256));
    var pathParams = const FunctionParameter("path", DynamicLengthArray(type: AddressType()));
    var toParams = const FunctionParameter("to", AddressType());
    var deadlineParams = const FunctionParameter("deadline", UintType(length: 256));
    input.add(amountOutParams);
    input.add(pathParams);
    input.add(toParams);
    input.add(deadlineParams);
    var function = ContractFunction("swapETHForExactTokens", input);
    var parameterList = [
      amountOut,
      path.map((e) => EthereumAddress.fromHex(e)).toList(),
      EthereumAddress.fromHex(toAddress),
      deadline,
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  Uint8List encodeSwapTokensForExactETH(
    BigInt amountOut,
    BigInt amountInMax,
    List<String> path,
    String toAddress,
    BigInt deadline,
  ) {
    List<FunctionParameter> input = [];
    var amountOutParams = const FunctionParameter("amountOut", UintType(length: 256));
    var amountInMaxParams = const FunctionParameter("amountInMax", UintType(length: 256));
    var pathParams = const FunctionParameter("path", DynamicLengthArray(type: AddressType()));
    var toParams = const FunctionParameter("to", AddressType());
    var deadlineParams = const FunctionParameter("deadline", UintType(length: 256));
    input.add(amountOutParams);
    input.add(amountInMaxParams);
    input.add(pathParams);
    input.add(toParams);
    input.add(deadlineParams);
    var function = ContractFunction("swapTokensForExactETH", input);
    var parameterList = [
      amountOut,
      amountInMax,
      path.map((e) => EthereumAddress.fromHex(e)).toList(),
      EthereumAddress.fromHex(toAddress),
      deadline,
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  Uint8List encodeSwapTokensForExactTokens(
    BigInt amountOut,
    BigInt amountInMax,
    List<String> path,
    String toAddress,
    BigInt deadline,
  ) {
    List<FunctionParameter> input = [];
    var amountOutParams = const FunctionParameter("amountOut", UintType(length: 256));
    var amountInMaxParams = const FunctionParameter("amountInMax", UintType(length: 256));
    var pathParams = const FunctionParameter("path", DynamicLengthArray(type: AddressType()));
    var toParams = const FunctionParameter("to", AddressType());
    var deadlineParams = const FunctionParameter("deadline", UintType(length: 256));
    input.add(amountOutParams);
    input.add(amountInMaxParams);
    input.add(pathParams);
    input.add(toParams);
    input.add(deadlineParams);

    var function = ContractFunction("swapTokensForExactTokens", input);
    var parameterList = [
      amountOut,
      amountInMax,
      path.map((e) => EthereumAddress.fromHex(e)).toList(),
      EthereumAddress.fromHex(toAddress),
      deadline,
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  Uint8List encodeSwapExactTokensForTokens(
    BigInt amountIn,
    BigInt amountOutMin,
    List<String> path,
    String toAddress,
    BigInt deadline,
  ) {
    List<FunctionParameter> input = [];
    var amountOutParams = const FunctionParameter("amountIn", UintType(length: 256));
    var amountInMaxParams = const FunctionParameter("amountOutMin", UintType(length: 256));
    var pathParams = const FunctionParameter("path", DynamicLengthArray(type: AddressType()));
    var toParams = const FunctionParameter("to", AddressType());
    var deadlineParams = const FunctionParameter("deadline", UintType(length: 256));
    input.add(amountOutParams);
    input.add(amountInMaxParams);
    input.add(pathParams);
    input.add(toParams);
    input.add(deadlineParams);
    var function = ContractFunction("swapExactTokensForTokens", input);
    var parameterList = [
      amountIn,
      amountOutMin,
      path.map((e) => EthereumAddress.fromHex(e)).toList(),
      EthereumAddress.fromHex(toAddress),
      deadline,
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// uniswap v3 ---
  /// token 换 token
  /// coin 换  token
  Uint8List encodeExactInputSingle(
    String tokenIn,
    String tokenOut,
    BigInt fee,
    String recipient,
    BigInt deadline,
    BigInt amountIn,
    BigInt amountOutMinimum,
  ) {
    List<FunctionParameter> input = [];
    var params = const FunctionParameter(
      "params",
      TupleType([
        AddressType(),
        AddressType(),
        UintType(length: 24),
        AddressType(),
        UintType(length: 256),
        UintType(length: 256),
        UintType(length: 256),
        UintType(length: 160),
      ]),
    );
    input.add(params);

    List<FunctionParameter> output = [];
    var amountOutParams = const FunctionParameter("amountOut", UintType(length: 256));
    output.add(amountOutParams);
    var function = ContractFunction("exactInputSingle", input, outputs: output);
    var parameterList = [
      [
        EthereumAddress.fromHex(tokenIn),
        EthereumAddress.fromHex(tokenOut),
        fee,
        EthereumAddress.fromHex(recipient),
        deadline,
        amountIn,
        amountOutMinimum,
        BigInt.zero,
      ],
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  Uint8List encodeExactInput(
    String path,
    String receiptAddress,
    BigInt deadline,
    BigInt amountIn,
    BigInt amountOutMinimum,
  ) {
    List<FunctionParameter> input = [];
    var params = const FunctionParameter(
      "params",
      TupleType([DynamicBytes(), AddressType(), UintType(length: 256), UintType(length: 256), UintType(length: 256)]),
    );
    input.add(params);

    List<FunctionParameter> output = [];
    var amountOutParams = const FunctionParameter("amountOut", UintType(length: 256));
    output.add(amountOutParams);
    var function = ContractFunction("exactInput", input, outputs: output);
    var parameterList = [
      [path.toUint8List(), EthereumAddress.fromHex(receiptAddress), deadline, amountIn, amountOutMinimum],
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// token 换 coin
  /// TODO: 添加 规则
  Uint8List encodeMulticall() {
    var function = ContractFunction("multicall", []);
    var parameterList = [];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// 根据输入计算输出， quoteExactInputSingle
  /// 第一个值是 amountOut
  /// 第二个值是 sqrtPriceX96After
  /// 第三个值 initializedTicksCrossed
  /// 第四个 gasEstimate
  Future<List<BigInt>> getQuoteExactInputSingle(
    String quoteContractAddres,
    String tokenInAddress,
    String tokenOutAddress,
    BigInt fee,
    BigInt amountIn,
    BigInt sqrtPriceLimitX96,
  ) async {
    List<FunctionParameter> input = [];
    var inputParams = const FunctionParameter(
      "params",
      TupleType([AddressType(), AddressType(), UintType(length: 256), UintType(length: 24), UintType(length: 160)]),
    );
    input.add(inputParams);
    List<FunctionParameter> output = [];
    var tokenOutputParams = const FunctionParameter("amountOut", UintType(length: 256));
    var sqrtPriceX96AfterParams = const FunctionParameter("sqrtPriceX96After", UintType(length: 160));
    var initializedTicksCrossedParams = const FunctionParameter("initializedTicksCrossed", UintType(length: 32));
    var gasEstimateParams = const FunctionParameter("gasEstimate", UintType(length: 256));
    output.add(tokenOutputParams);
    output.add(sqrtPriceX96AfterParams);
    output.add(initializedTicksCrossedParams);
    output.add(gasEstimateParams);

    var function = ContractFunction("quoteExactInputSingle", input, outputs: output);
    var parameterList = [
      [
        EthereumAddress.fromHex(tokenInAddress),
        EthereumAddress.fromHex(tokenOutAddress),
        amountIn,
        fee,
        sqrtPriceLimitX96,
      ],
    ];
    var encoded = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(quoteContractAddres),
      data: encoded,
    );
    var result = function.decodeReturnValues(res);
    List<BigInt> list = [];
    list.add(result[0]);
    list.add(result[1]);
    list.add(result[2]);
    list.add(result[3]);
    return list;
  }

  Future<BigInt> getV3Fee(String pairContractAddress) async {
    List<FunctionParameter> input = [];

    List<FunctionParameter> output = [];
    var tokenOutputParams = const FunctionParameter("", UintType(length: 24));
    output.add(tokenOutputParams);

    var function = ContractFunction("fee", input, outputs: output);
    var parameterList = [];

    var encoded = function.encodeCall(parameterList);

    var res = await mWeb3Client.callRaw(
      sender: null,
      contract: EthereumAddress.fromHex(pairContractAddress),
      data: encoded,
    );
    var result = function.decodeReturnValues(res);
    var amount = result[0];
    return amount;
  }

  String encodePath(List<String> path, List<int> fees) {
    if (path.length != fees.length + 1) {
      throw Exception('path/fee lengths do not match');
    }
    String encoded = '0x';
    for (int i = 0; i < fees.length; i++) {
      // 20 byte encoding of the address
      encoded += path[i].substring(2);
      // 3 byte encoding of the fee
      int feeSize = 3; // Replace FEE_SIZE with the appropriate value if not defined elsewhere
      encoded += fees[i].toRadixString(16).padLeft(2 * feeSize, '0');
    }
    // encode the final token
    encoded += path[path.length - 1].substring(2);
    return encoded.toLowerCase();
  }

  // /// [chainId] evm chain id
  // /// [callDataLength] encode data length
  // int getPreEstimateFee(int chainId, int callDataLength) {
  //   var params = estimateFeeParams[chainId]!;
  //   return ((callDataLength / 2) * (params.feePerByte) + (params.feeBase)).toInt();
  // }

  // var estimateFeeParams = {
  //   1: PYFeeParams(feeBase: 110000, feePerByte: 130),
  //   56: PYFeeParams(feeBase: 120000, feePerByte: 130),
  //   42161: PYFeeParams(feeBase: 250000, feePerByte: 4000),
  //   10: PYFeeParams(feeBase: 880000, feePerByte: 150),
  //   137: PYFeeParams(feeBase: 880000, feePerByte: 150),
  //   324: PYFeeParams(feeBase: 880000, feePerByte: 150),
  // };

  /// stargate quoteLayerZeroFee
  Future<BigInt> stargateQuoteLayerZeroFee(int dstChainId, String account, String contractRouter) async {
    List<FunctionParameter> input = [];
    var dstChainIdParams = const FunctionParameter("_dstChainId", UintType(length: 16));
    var functionTypeParams = const FunctionParameter("_functionType", UintType(length: 8));
    var toAddressParams = const FunctionParameter("_toAddress", DynamicBytes());
    var transferAndCallPayloadParams = const FunctionParameter("_transferAndCallPayload", DynamicBytes());
    var componentsParams = const FunctionParameter(
      "_lzTxParams",
      TupleType([UintType(length: 256), UintType(length: 256), DynamicBytes()]),
    );
    input.add(dstChainIdParams);
    input.add(functionTypeParams);
    input.add(toAddressParams);
    input.add(transferAndCallPayloadParams);
    input.add(componentsParams);
    List<FunctionParameter> output = [];
    var oneParams = const FunctionParameter("", UintType(length: 256));
    var twoParams = const FunctionParameter("", UintType(length: 256));
    output.add(oneParams);
    output.add(twoParams);
    var function = ContractFunction("quoteLayerZeroFee", input, outputs: output);
    var parameterList = [
      BigInt.from(dstChainId),
      BigInt.one,
      account.toUint8List(),
      '0x'.toUint8List(),
      [BigInt.zero, BigInt.zero, '0x'.toUint8List()],
    ];
    var encoded = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractRouter), data: encoded);
    var result = function.decodeReturnValues(res);
    var amount = result[0];
    return amount;
  }

  /// encode stargate swap
  Uint8List encodeStargateSwap(
    int dstChainId,
    int poolId,
    String account,
    BigInt bridgeAmount,
    BigInt bridgeAmountMinOut,
  ) {
    List<FunctionParameter> input = [];
    var dstChainIdParams = const FunctionParameter("_dstChainId", UintType(length: 16));
    var srcPoolIdParams = const FunctionParameter("_srcPoolId", UintType(length: 256));
    var dstPoolIdParams = const FunctionParameter("_dstPoolId", UintType(length: 256));
    var refundAddressParams = const FunctionParameter("_refundAddress", AddressType());
    var amountLDParams = const FunctionParameter("_amountLD", UintType(length: 256));
    var minAmountLDParams = const FunctionParameter("_minAmountLD", UintType(length: 256));
    var componentsParams = const FunctionParameter(
      "_lzTxParams",
      TupleType([UintType(length: 256), UintType(length: 256), DynamicBytes()]),
    );
    var toParams = const FunctionParameter("_to", DynamicBytes());
    var payloadParams = const FunctionParameter("_payload", DynamicBytes());
    input.add(dstChainIdParams);
    input.add(srcPoolIdParams);
    input.add(dstPoolIdParams);
    input.add(refundAddressParams);
    input.add(amountLDParams);
    input.add(minAmountLDParams);
    input.add(componentsParams);
    input.add(toParams);
    input.add(payloadParams);
    var function = ContractFunction("swap", input);
    var parameterList = [
      BigInt.from(dstChainId),
      BigInt.from(poolId),
      BigInt.from(poolId),
      EthereumAddress.fromHex(account),
      bridgeAmount,
      bridgeAmountMinOut,
      [BigInt.zero, BigInt.zero, '0x'.toUint8List()],
      account.toUint8List(),
      '0x'.toUint8List(),
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// encode stargate swapETH
  Uint8List encodeStargateSwapETH(int dstChainId, String account, BigInt bridgeAmount, BigInt bridgeAmountMinOut) {
    List<FunctionParameter> input = [];
    var dstChainIdParams = const FunctionParameter("_dstChainId", UintType(length: 16));
    var refundAddressParams = const FunctionParameter("_refundAddress", AddressType());
    var toAddressParams = const FunctionParameter("_toAddress", DynamicBytes());
    var amountLDParams = const FunctionParameter("_amountLD", UintType(length: 256));
    var minAmountLDParams = const FunctionParameter("_minAmountLD", UintType(length: 256));
    input.add(dstChainIdParams);
    input.add(refundAddressParams);
    input.add(toAddressParams);
    input.add(amountLDParams);
    input.add(minAmountLDParams);
    List<FunctionParameter> output = [];
    var function = ContractFunction("swapETH", input, outputs: output);
    var parameterList = [
      BigInt.from(dstChainId),
      EthereumAddress.fromHex(account),
      account.toUint8List(),
      bridgeAmount,
      bridgeAmountMinOut,
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// arbirum approve address
  Future<String> arbirumApproveAddress(String token, String contractRouter) async {
    List<FunctionParameter> input = [];
    var tokenParams = const FunctionParameter("_token", AddressType());
    input.add(tokenParams);
    List<FunctionParameter> output = [];
    var oneParams = const FunctionParameter("gateway", AddressType());
    output.add(oneParams);
    var function = ContractFunction("getGateway", input, outputs: output);
    var parameterList = [EthereumAddress.fromHex(token)];
    var encoded = function.encodeCall(parameterList);
    var res = await mWeb3Client.callRaw(sender: null, contract: EthereumAddress.fromHex(contractRouter), data: encoded);
    var result = function.decodeReturnValues(res);
    EthereumAddress approveAddress = result[0];
    return approveAddress.hexEip55;
  }

  /// encode arbirum bridge
  Uint8List encodeArbirumBridge(String token, String refundTo, String to, BigInt amount, Uint8List data) {
    List<FunctionParameter> input = [];
    var tokenParams = const FunctionParameter("_token", AddressType());
    var refundToParams = const FunctionParameter("_refundTo", AddressType());
    var toParams = const FunctionParameter("_to", AddressType());
    var amountParams = const FunctionParameter("_amount", UintType(length: 256));
    var maxGasParams = const FunctionParameter("_maxGas", UintType(length: 256));
    var gasPriceBidParams = const FunctionParameter("_gasPriceBid", UintType(length: 256));
    var dataParams = const FunctionParameter("_data", DynamicBytes());
    input.add(tokenParams);
    input.add(refundToParams);
    input.add(toParams);
    input.add(amountParams);
    input.add(maxGasParams);
    input.add(gasPriceBidParams);
    input.add(dataParams);
    List<FunctionParameter> output = [];
    var oneParams = const FunctionParameter("", DynamicBytes());
    output.add(oneParams);
    var function = ContractFunction("outboundTransferCustomRefund", input, outputs: output);
    var parameterList = [
      EthereumAddress.fromHex(token),
      EthereumAddress.fromHex(refundTo),
      EthereumAddress.fromHex(to),
      amount,
      BigInt.from(275000),
      BigInt.from(300000000),
      data,
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// encode optimism depositERC20
  Uint8List encodeOptimismDepositERC20(String l1Token, String l2Token, BigInt amount, Uint8List extraData) {
    List<FunctionParameter> input = [];
    var l1TokenParams = const FunctionParameter("_l1Token", AddressType());
    var l2TokenParams = const FunctionParameter("_l2Token", AddressType());
    var amountParams = const FunctionParameter("_amount", UintType(length: 256));
    var minGasLimitParams = const FunctionParameter("_minGasLimit", UintType(length: 32));
    var extraDataParams = const FunctionParameter("_extraData", DynamicBytes());
    input.add(l1TokenParams);
    input.add(l2TokenParams);
    input.add(amountParams);
    input.add(minGasLimitParams);
    input.add(extraDataParams);
    var function = ContractFunction("depositERC20", input);
    var parameterList = [
      EthereumAddress.fromHex(l1Token),
      EthereumAddress.fromHex(l2Token),
      amount,
      BigInt.from(200000),
      extraData,
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// encode optimism depositETH
  Uint8List encodeOptimismDepositETH(Uint8List extraData) {
    List<FunctionParameter> input = [];
    var minGasLimitParams = const FunctionParameter("_minGasLimit", UintType(length: 32));
    var extraDataParams = const FunctionParameter("_extraData", DynamicBytes());
    input.add(minGasLimitParams);
    input.add(extraDataParams);
    List<FunctionParameter> output = [];
    var function = ContractFunction("depositETH", input, outputs: output);
    var parameterList = [BigInt.from(200000), extraData];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// encode zksync deposit
  Uint8List encodeZKSyncDeposit(String l2Receiver, String l1Token, BigInt amount) {
    List<FunctionParameter> input = [];
    var oneParams = const FunctionParameter("_l2Receiver", AddressType());
    var twoParams = const FunctionParameter("_l1Token", AddressType());
    var threeParams = const FunctionParameter("_amount", UintType(length: 256));
    var fourParams = const FunctionParameter("_l2TxGasLimit", UintType(length: 256));
    var fiveParams = const FunctionParameter("_l2TxGasPerPubdataByte", UintType(length: 256));
    input.add(oneParams);
    input.add(twoParams);
    input.add(threeParams);
    input.add(fourParams);
    input.add(fiveParams);
    var function = ContractFunction("deposit", input);
    var parameterList = [
      EthereumAddress.fromHex(l2Receiver),
      EthereumAddress.fromHex(l1Token),
      amount,
      BigInt.from(1000000),
      BigInt.from(800),
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// encode zksync requestL2Transaction
  Uint8List encodeZKSyncRequestL2Transaction(String contractL2, BigInt l2Value, String refundRecipient) {
    List<FunctionParameter> input = [];
    var oneParams = const FunctionParameter("_contractL2", AddressType());
    var twoParams = const FunctionParameter("_l2Value", UintType(length: 256));
    var threeParams = const FunctionParameter("_calldata", DynamicBytes());
    var fourParams = const FunctionParameter("_l2GasLimit", UintType(length: 256));
    var fiveParams = const FunctionParameter("_l2GasPerPubdataByteLimit", UintType(length: 256));
    var sixParams = const FunctionParameter("_factoryDeps", DynamicLengthArray(type: DynamicBytes()));
    var sevenParams = const FunctionParameter("_refundRecipient", AddressType());
    input.add(oneParams);
    input.add(twoParams);
    input.add(threeParams);
    input.add(fourParams);
    input.add(fiveParams);
    input.add(sixParams);
    input.add(sevenParams);
    var function = ContractFunction("requestL2Transaction", input);
    var parameterList = [
      EthereumAddress.fromHex(contractL2),
      l2Value,
      '0x'.toUint8List(),
      BigInt.from(722221),
      BigInt.from(800),
      List<Uint8List>.empty(),
      EthereumAddress.fromHex(refundRecipient),
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  /// encode cbridge send
  Uint8List encodeCBridgeSend(
    String receiver,
    String token,
    BigInt amount,
    int dstChainId,
    int nonce,
    int maxSlippage,
  ) {
    List<FunctionParameter> input = [];
    var receiverParams = const FunctionParameter("_receiver", AddressType());
    var tokenParams = const FunctionParameter("_token", AddressType());
    var amountParams = const FunctionParameter("_amount", UintType(length: 256));
    var dstChainIdParams = const FunctionParameter("_dstChainId", UintType(length: 64));
    var nonceParams = const FunctionParameter("_nonce", UintType(length: 64));
    var maxSlippageParams = const FunctionParameter("_maxSlippage", UintType(length: 32));
    input.add(receiverParams);
    input.add(tokenParams);
    input.add(amountParams);
    input.add(dstChainIdParams);
    input.add(nonceParams);
    input.add(maxSlippageParams);
    List<FunctionParameter> output = [];
    var function = ContractFunction("send", input, outputs: output);
    var parameterList = [
      EthereumAddress.fromHex(receiver),
      EthereumAddress.fromHex(token),
      amount,
      BigInt.from(dstChainId),
      BigInt.from(nonce),
      BigInt.from(maxSlippage),
    ];
    var encoded = function.encodeCall(parameterList);
    return encoded;
  }

  Future<bool> isSupportEIP1559() async {
    // 某些链可能支持EIP1559协议， 但是并不完全支持使用1559手续费模式，如 Celo, 再判断eth_feeHistory有正确返回时才完全支持1559
    // Neox 本质支持1559 但 eth_feeHistory 返回0，需要验证小费是否存在大于0的值， 大于零才支持使用， 否则判断为不使用1559
    try {
      bool hasPriorityFee = false;
      final blockHeader = await mWeb3Client.getBlockInformation(isContainFullObj: false);
      // 如果包含block头包含 baseFeePerGas 则说明该evm支持EIP1559
      final has1559Header = blockHeader.baseFeePerGas;
      // feeHistory
      List<double> rewardPercentiles = [25, 50, 70];
      final feeHistory = await mWeb3Client.getFeeHistory(5, rewardPercentiles: rewardPercentiles);
      if (feeHistory['reward'] != null) {
        for (int index = 0; index < rewardPercentiles.length; index++) {
          final List<BigInt> allPriorityFee =
              feeHistory['reward']!.map<BigInt>((e) {
                return e[index] as BigInt;
              }).toList();

          final priorityFee = allPriorityFee.reduce((curr, next) => curr > next ? curr : next);

          if (priorityFee == BigInt.zero) {
            hasPriorityFee = false;
            break;
          } else {
            hasPriorityFee = true;
          }
        }
      }
      return (has1559Header != null) && hasPriorityFee;
    } catch (_) {
      log('不支持获取费用历史');
      return false;
    }
  }

  // Future<bool> isSupportEIP4844() async {
  //   final blockHeader = await mWeb3Client.getBlockInformation(isContainFullObj: false);
  //   // 如果包含block头包含 blobGasUsed  和 excessBlobGas 则说明该evm支持EIP4844
  //   final hasBlobHeader = blockHeader.baseFeePerGas('blobGasUsed') && blockHeader.containsKey('excessBlobGas');
  //   // 某些链可能支持EIP1559/4844协议， 但是并不完全支持使用1559手续费模式, 则判定也不支持4844
  //   bool hasFeeHistory = false;
  //   try {
  //     final feeHistory = await mWeb3Client.getFeeHistory(5, rewardPercentiles: [25, 50, 75]);
  //     hasFeeHistory = feeHistory['reward'] != null;
  //   } catch (_) {
  //     log('不支持获取费用历史');
  //     hasFeeHistory = false;
  //   }
  //   return hasBlobHeader && hasFeeHistory;
  // }
}

class LengthTrackingByte extends ByteConversionSinkBase {
  final Uint8Buffer _buffer = Uint8Buffer();
  int _length = 0;

  int get length => _length;

  Uint8List asBytes() {
    return _buffer.buffer.asUint8List(0, _length);
  }

  @override
  void add(List<int> chunk) {
    _buffer.addAll(chunk);
    _length += chunk.length;
  }

  void addByte(int byte) {
    _buffer.add(byte);
    _length++;
  }

  void setRange(int start, int end, List<int> content) {
    _buffer.setRange(start, end, content);
  }

  @override
  void close() {
    // no-op, never used
  }
}
