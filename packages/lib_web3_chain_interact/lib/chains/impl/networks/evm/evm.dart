import 'dart:typed_data';

import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_web3_chain_interact/base/i_ab_web3_network.dart';
import 'package:lib_web3_chain_interact/chains/impl/networks/evm/transaction_impl.dart';
import 'package:lib_web3_chain_interact/chains/interface/networks/evm.dart';
import 'package:lib_web3_chain_interact/signer/signer.dart';
import 'package:lib_web3_core/rpc/evm_chain_method.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';

final class ABWeb3EVMNetworkImpl extends ABWeb3EVMNetwork with IABWeb3Network {
  ABWeb3EVMNetworkImpl({required ABChainInfo chainInfo}) : super.internal(chainInfo);

  EVMChainMethod? _method;

  Future<EVMChainMethod> getRpcMethod() async {
    _method ??= EVMChainMethod(mChainInfo.endpoints.rpcAddresses![0]);
    return _method!;
  }

  @override
  Future<String> get symbol => Future.value(mChainInfo.mainTokenInfo.tokenSymbol);

  @override
  Future<String> get name => Future.value(mChainInfo.mainTokenInfo.tokenName);

  @override
  Future<BigInt> getBalance({required String address}) async {
    final balance = await (await getRpcMethod()).getBalance(address);
    return balance;
  }

  @override
  Future<BigInt> getErc20TokenBalance({required String address, required String tokenAddress}) async {
    final balance = await (await getRpcMethod()).getTokenBalance(tokenAddress, address);
    return balance;
  }

  @override
  Future<ABWeb3EVMTransaction> buildContractTx({
    required String from,
    required String contractAddress,
    required Uint8List data,
    required BigInt value,
    bool? isEnablingEIP1559,
  }) async {
    return ABWeb3EVMTransactionImpl(
      from: from,
      to: contractAddress,
      value: value,
      data: data,
      isEnablingEIP1559: isEnablingEIP1559,
    );
  }

  @override
  Future<ABWeb3EVMTransaction> buildErc20TokenTransferTx({
    required String from,
    required String to,
    required BigInt amount,
    required String tokenAddress,
  }) async {
    if (from.isEmpty || to.isEmpty) throw ArgumentError("from and to can not be empty");
    final method = await getRpcMethod();
    final data = method.encodeERC20Transfer(from, to, amount);
    return ABWeb3EVMTransactionImpl(from: from, to: tokenAddress, value: BigInt.zero, data: data);
  }

  @override
  Future<ABWeb3EVMTransaction> buildTransferTx({
    required String from,
    required String to,
    required BigInt amount,
  }) async {
    if (from.isEmpty || to.isEmpty) throw ArgumentError("from and to can not be empty");
    return ABWeb3EVMTransactionImpl(from: from, to: to, value: amount);
  }

  @override
  Future<BigInt> estimateGas({required ABWeb3EVMTransaction tx}) async {
    tx as ABWeb3EVMTransactionImpl;
    final method = await getRpcMethod();
    final supportEip1559 = tx.isEnablingEIP1559 ?? await method.isSupportEIP1559();
    final gasLimit = await method.estimateGasV2(fromAddress: tx.from, toAddress: tx.to, data: tx.data, value: tx.value);
    tx.setGasLimit(gasLimit);

    BigInt l1Gas = BigInt.zero;
    if (tx.l1GasContract != null) {
      l1Gas = BigInt.from(await method.getL1Fee(tx.data ?? Uint8List(0)));
    }
    if (supportEip1559) {
      final gasPrice1559 = await method.getGasInEip1559();
      tx.setMaxFeePerGas(gasPrice1559[1].maxFeePerGas);
      tx.setMaxPriorityFeePerGas(gasPrice1559[1].maxPriorityFeePerGas);
      return gasPrice1559[1].estimatedGas * gasLimit + l1Gas;
    } else {
      final gasPrice = await method.gasPrice();
      tx.setGasPrice(gasPrice);
      return gasPrice * gasLimit + l1Gas;
    }
  }

  @override
  Future<List<ABWeb3EVMSentTransaction>> sendTxs({required List<ABWeb3EVMSignedTransaction> txs}) async {
    final method = await getRpcMethod();
    final sentTx = <ABWeb3EVMSentTransaction>[];
    for (ABWeb3EVMSignedTransaction tx in txs) {
      final hash = await method.sendRawTransaction(tx.signedRaw.toUint8List());
      final sent = ABWeb3EVMSentTransactionImpl(hash: hash, signedRaw: tx.signedRaw);
      sentTx.add(sent);
    }
    return sentTx;
  }

  @override
  Future<List<ABWeb3EVMSignedTransaction>> signTxs({
    required List<ABWeb3EVMTransaction> txs,
    required ABWeb3Signer signer,
  }) async {
    final signedList = <ABWeb3EVMSignedTransaction>[];

    if (signer is ABWeb3HardwareSigner) {
    } else if (signer is ABWeb3KeypairSigner) {}

    final method = await getRpcMethod();
    // 获取首个 nonce
    int initNonce = await method.getTransactionCount(txs.first.from);
    final chainId = await method.getNetworkId();
    final privateKeySigner = signer as ABWeb3PrivateKeySigner;

    /// fileCoin 强制要求走 EIP1559
    final isFileCoin = chainId == 314;

    for (ABWeb3EVMTransaction tx in txs) {
      /// 如果没有手动预估手续费，使用默认值
      if (tx.gasLimit == null) {
        await estimateGas(tx: tx);
      }

      if (isFileCoin) {
        assert(tx.maxFeePerGas != null, 'FileCoin must contain maxFeePerGas');
        assert(tx.maxPriorityFeePerGas != null, 'FileCoin must contain maxFeePerGas');
      }

      final signed = method.signEVMTransaction(
        chainId,
        initNonce,
        tx.gasPrice!,
        tx.gasLimit!,
        tx.value,
        tx.maxFeePerGas,
        tx.maxPriorityFeePerGas,
        tx.to,
        privateKeySigner.privateKey,
        tx.data,
        60,
      );
      // 多条签名，nonce自增1
      initNonce += 1;
      final signedTx = ABWeb3EVMSignedTransactionImpl(signed);
      signedList.add(signedTx);
    }
    return signedList;
  }

  @override
  Future<ABWeb3EVMTransaction> buildEIP4844Tx({
    required String from,
    required String to,
    required BigInt amount,
    required Sidecar sidecar,
  }) async {
    return ABWeb3EVMTransactionImpl(from: from, to: to, value: amount, sidecar: sidecar);
  }

  @override
  Future<ABWeb3EVMUnsignedTransaction> buildUnsignedTx({required ABWeb3EVMTransaction tx}) async {
    final method = await getRpcMethod();
    final nonce = await method.getTransactionCount(tx.from);
    final chainId = await method.getNetworkId();
    eip1559FeeCheck(chainId, tx.maxFeePerGas, tx.maxPriorityFeePerGas);
    await estimateGas(tx: tx);
    return ABWeb3EVMUnsignedTransactionImpl(
      from: tx.from,
      to: tx.to,
      value: tx.value,
      data: tx.data,
      nonce: nonce,
      chainId: chainId,
      gasLimit: tx.gasLimit!,
      gasPrice: tx.gasPrice,
      maxFeePerGas: tx.maxFeePerGas,
      maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
      maxFeePerBlobGas: tx.maxFeePerBlobGas,
      sidecar: tx.sidecar,
    );
  }

  void eip1559FeeCheck(int chainId, BigInt? maxFeePerGas, BigInt? maxPriorityFeePerGas) {
    /// 某些链如 fileCoin evm 链 chainId = 314, 强制要求走 EIP1559
    switch (chainId) {
      case 314:
        if (maxFeePerGas == null || maxPriorityFeePerGas == null) throw ("File coin tx must set eip1559 fee");
    }
  }

  @override
  Future<ABWeb3EVMTransaction> buildApproveTx({
    required String owner,
    required String spender,
    required String tokenAddress,
    BigInt? amount,
    bool? isEnablingEIP1559,
  }) async {
    final method = await getRpcMethod();

    // 传入的 amount 为 null 时，视为无限授权, 以太坊amount最大值为 uint256 即 2^256-1， 16进制为
    // ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    // 避免直接幂运算， 使用16进制值进行转换
    amount ??= BigInt.parse("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", radix: 16);
    final data = method.encodeERC20Approve(spender, amount);

    return ABWeb3EVMTransactionImpl(
      from: owner,
      to: tokenAddress,
      // eth 不需要给值
      value: BigInt.zero,
      data: data,
      isEnablingEIP1559: isEnablingEIP1559,
      isApprove: true,
    );
  }

  @override
  Future<BigInt> allowance({required String tokenAddress, required String owner, required String spender}) async {
    final method = await getRpcMethod();
    return method.getERC20Allowance(tokenAddress, owner, spender);
  }

  @override
  Future<BigInt> getL1Gas({required Uint8List tx, required String chainKey}) async {
    final method = await getRpcMethod();
    return method.getL1FeeV2(dataTx: tx, chainKey: chainKey);
  }
}
