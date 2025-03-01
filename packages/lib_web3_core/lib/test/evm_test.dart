import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:lib_base/logger/ab_logger.dart';
import 'package:lib_web3_core/impl/wallet_method_impl.dart';
import 'package:lib_web3_core/rpc/evm_chain_method.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_trust_wallet_core/protobuf/Ethereum.pb.dart' as Ethereum;

class EvmTest {
  void test() async {
    transferTest();
  }

  void transferTest() async {
    ABLogger.d("start...");
    var mnemonic = "gym avoid gentle stereo code yard kangaroo leisure merge piece permit inch";
    var rpc = "https://jp.rpc.mainnet.newtonproject.org";
    int coinType = TWCoinType.TWCoinTypeNewChain;
    var wallet = await WalletMethod.instance.createAccountByMnemonicAndType(mnemonic: mnemonic, coinType: coinType);
    var rpcMehod = EVMChainMethod(rpc);
    var chainId = await rpcMehod.mWeb3Client.getChainId();
    // get fee history
    // var feeList = await rpcMehod.getGasInEip1559();
    var balance = await rpcMehod.getBalance(wallet.accountAddress);
    ABLogger.d("balance: ${balance}");
    // 中
    // var usedFee = feeList[2];
    // ABLogger.d(usedFee.toString());
    var nonce = await rpcMehod.getTransactionCount(wallet.accountAddress);
    var gasPrice = await rpcMehod.gasPrice();
    ABLogger.d("gasPrice: ${gasPrice}");
    var gasLimit = await rpcMehod.estimateGas(
      fromAddress: wallet.accountAddress,
      toAddress: wallet.accountAddress,
      value: EtherAmount.zero(),
    );
    // ABLogger.d("estimatedGas is: ${usedFee.estimatedGas * gasLimit}");
    // ABLogger.d("maxFeePerGas is: ${usedFee.maxFeePerGas * gasLimit}");
    // ABLogger.d("maxPriorityFeePerGas is: ${usedFee.maxPriorityFeePerGas * gasLimit}");
    var res = rpcMehod.signEVMTransaction(
      chainId.toInt(),
      nonce,
      gasPrice!,
      gasLimit,
      BigInt.from(1),
      null,
      null,
      // usedFee.maxFeePerGas, // 用于愿意支付的最大 perGas
      // usedFee.maxPriorityFeePerGas, // 直接给旷工的小费
      wallet.accountAddress,
      wallet.accountPrivateKey,
      null,
      coinType,
      mode: Ethereum.TransactionMode.Legacy,
    );
    ABLogger.d(res);
    // var txid = await rpcMehod.sendRawTransaction(res.toUint8List());
    // ABLogger.d(txid);
  }
}
