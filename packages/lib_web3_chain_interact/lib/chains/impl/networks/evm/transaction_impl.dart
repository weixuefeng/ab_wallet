import 'dart:typed_data';

import 'package:lib_web3_chain_interact/chains/interface/networks/evm.dart';

final class ABWeb3EVMTransactionImpl extends ABWeb3EVMTransaction {
  @override
  final String from;
  @override
  final String to;
  @override
  final BigInt value;
  @override
  final Uint8List? data;

  @override
  BigInt? gasLimit;
  @override
  BigInt? gasPrice;
  @override
  BigInt? maxFeePerGas;
  @override
  BigInt? maxPriorityFeePerGas;
  @override
  BigInt? maxFeePerBlobGas;
  @override
  Sidecar? sidecar;
  @override
  String? l1GasContract;

  bool? isEnablingEIP1559;

  final bool isApprove;

  ABWeb3EVMTransactionImpl({
    required this.from,
    required this.to,
    required this.value,

    this.data,
    this.gasLimit,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.maxFeePerBlobGas,
    this.sidecar,
    this.l1GasContract,
    this.isEnablingEIP1559,
    this.isApprove = false,
  });

  @override
  void setGasLimit(BigInt gasLimit) {
    this.gasLimit = gasLimit;
  }

  @override
  void setGasPrice(BigInt gasPrice) {
    this.gasPrice = gasPrice;
  }

  @override
  void setMaxFeePerGas(BigInt maxFeePerGas) {
    this.maxFeePerGas = maxFeePerGas;
  }

  @override
  void setMaxPriorityFeePerGas(BigInt maxPriorityFeePerGas) {
    this.maxPriorityFeePerGas = maxPriorityFeePerGas;
  }

  @override
  void setMaxFeePerBlobGas(BigInt maxFeePerBlobGas) {
    this.maxFeePerBlobGas = maxFeePerBlobGas;
  }
}

final class ABWeb3EVMSignedTransactionImpl extends ABWeb3EVMSignedTransaction {
  @override
  final String signedRaw;

  ABWeb3EVMSignedTransactionImpl(this.signedRaw);
}

final class ABWeb3EVMSentTransactionImpl extends ABWeb3EVMSentTransaction {
  @override
  final String hash;

  final String signedRaw;

  ABWeb3EVMSentTransactionImpl({required this.hash, required this.signedRaw});
}

final class ABWeb3EVMUnsignedTransactionImpl extends ABWeb3EVMUnsignedTransaction {
  final String from;
  final String to;
  final BigInt value;
  final int nonce;
  final int chainId;
  final Uint8List? data;
  final BigInt gasLimit;
  final BigInt? gasPrice;
  final BigInt? maxFeePerGas;
  final BigInt? maxPriorityFeePerGas;
  final BigInt? maxFeePerBlobGas;
  final Sidecar? sidecar;

  /// 序列化之后的交易，序列化方式待定
  final Uint8List? rawTx;

  ABWeb3EVMUnsignedTransactionImpl({
    required this.from,
    required this.to,
    required this.value,
    required this.nonce,
    required this.chainId,
    this.data,
    required this.gasLimit,
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.maxFeePerBlobGas,
    this.sidecar,
    this.rawTx,
  });
}
