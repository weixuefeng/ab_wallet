import 'package:decimal/decimal.dart';
import 'dart:typed_data';
import 'package:lib_web3_core/impl/chain_method_impl.dart';
import 'package:lib_web3_core/interaction/chains/chains.dart';
import 'package:lib_web3_core/interaction/gas/gas.dart';
import 'package:lib_web3_core/interaction/gas/model/evm.dart';
import 'package:lib_web3_core/interaction/exception/gas_service_exception.dart';
import 'package:lib_web3_core/interaction/provider/gas_provider.dart';
import 'package:lib_web3_core/interface/chain_method_interface.dart';
import 'package:lib_web3_interaction/chains/evm/evm_impl.dart';
import 'package:lib_web3_interaction/chains/evm/gas_impl.dart';
import 'package:lib_web3_interaction/service/constants.dart';
import 'package:lib_web3_interaction/service/evm_gas_service.dart';
import 'package:lib_web3_interaction/chains/public/functions.dart';

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
  final int networkId;
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

  late ABWeb3EVMChainWrapper _abWeb3Network;

  final bool isApprove;

  // 保存最新的缓存值，避免点击时再缓存
  ABWeb3EvmGasFeeLevel? _gasLevelCache;

  ABWeb3EVMTransactionImpl({
    required this.from,
    required this.to,
    required this.value,
    required this.networkId,
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
  }) {
    _abWeb3Network = ABWeb3Chain.factory(networkId) as ABWeb3EVMChainWrapper;
  }

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

  @override
  Future<bool> get canSelectGasFee => Future.value(true);

  @override
  Future<bool> get canCustom => Future.value(true);

  @override
  Future<ABWeb3GasFee> estimateGasV2({
    ABWeb3GasFee? abWeb3GasFee,
    GasFeeType gasFeeType = GasFeeType.fast,
  }) async {
    if (abWeb3GasFee?.type == GasFeeType.custom) {
      return abWeb3GasFee!;
    }
    _gasLevelCache = await _getEvmGas();

    /// 默认使用fast值更新交易手续费
    final currentSelectedGas = _gasLevelCache!.getGasFeeByType(
      abWeb3GasFee?.type ?? gasFeeType,
    );
    _updateTxGas(_gasLevelCache!.isEIP1559, currentSelectedGas);
    return currentSelectedGas;
  }

  @override
  Future<ABWeb3GasFeeLevels> estimateGasV3({
    ABWeb3GasFeeLevels? abWeb3GasFeeLevels,
    GasFeeType gasFeeType = GasFeeType.fast,
  }) async {
    if (abWeb3GasFeeLevels != null &&
        abWeb3GasFeeLevels.custom != null &&
        gasFeeType == GasFeeType.custom) {
      return abWeb3GasFeeLevels;
    }
    _gasLevelCache = await _getEvmGas();

    /// 默认使用fast值更新交易手续费
    final currentSelectedGas = _gasLevelCache!.getGasFeeByType(gasFeeType);
    _updateTxGas(_gasLevelCache!.isEIP1559, currentSelectedGas);
    return _gasLevelCache!;
  }

  @override
  Future<ABWeb3GasFeeLevels> getGasFeeLevels() async {
    _gasLevelCache = await _getEvmGas();
    return ABWeb3EvmGasFeeLevel(
      low: _gasLevelCache!.low,
      avg: _gasLevelCache!.avg,
      fast: _gasLevelCache!.fast,
      isEIP1559: _gasLevelCache!.fast.isEIP1559,
    );
  }

  /// 后端获取gasPrice和 gasLimit
  Future<ABWeb3EvmGasFeeLevel> _getEvmGas() async {
    try {
      /// 后端获取gasPrice和 gasLimit
      final gasPriceModel = await ABWeb3EVMGasService.instance.getGasPrice(
        networkId,
      );
      final gasLimitModel = await ABWeb3EVMGasService.instance.getGasLimit(
        networkId,
        ABWeb3EVMGasLimitRequestParams(
          from: from,
          to: to,
          // 服务端要求data是0x开头的16进制, 如果没有，则默认传0x
          // data: data?.toHex() ?? '0x',
          data:  '0x',
          // 服务端要求value是0x开头的16进制
          value: '0x${value.toRadixString(16)}',

          isApprove: isApprove,
        ),
      );
      final l1GasFee = await _getL1Gas();
      // final gasLimitFromBackend = isApprove ? gasLimitModel.approveGasUsed : gasLimitModel.gasUsed;
      final gasLimitFromBackend = isApprove ? 1 : 1;

      /// 获取币价
      // final ethPriceInUsd = Decimal.parse(gasPriceModel.nativeCoinPrice);
      final ethPriceInUsd = Decimal.parse("2");

      /// 计算总消耗的ETH，单位为wei
      final totalFeeInWeiLow =
          (gasPriceModel.lowPriWeiPerGas + gasPriceModel.baseWeiFee) *
              BigInt.from(gasLimitFromBackend) +
          l1GasFee;
      final totalFeeInWeiAvg =
          (gasPriceModel.avgPriWeiPerGas + gasPriceModel.baseWeiFee) *
              BigInt.from(gasLimitFromBackend) +
          l1GasFee;
      final totalFeeInWeiFast =
          (gasPriceModel.fastPriWeiPerGas + gasPriceModel.baseWeiFee) *
              BigInt.from(gasLimitFromBackend) +
          l1GasFee;

      /// 按照原油逻辑， maxFeePerGas 为 base+ priority 的1.5 倍
      final lowMaxFeePerGas = BigInt.from(
        1.5 *
            (gasPriceModel.lowPriWeiPerGas + gasPriceModel.baseWeiFee)
                .toDouble(),
      );
      final avgMaxFeePerGas = BigInt.from(
        1.5 *
            (gasPriceModel.avgPriWeiPerGas + gasPriceModel.baseWeiFee)
                .toDouble(),
      );
      final fastMaxFeePerGas = BigInt.from(
        1.5 *
            (gasPriceModel.fastPriWeiPerGas + gasPriceModel.baseWeiFee)
                .toDouble(),
      );

      final totalFeeInETHLow = await _abWeb3Network.convertBigIntToDecimal(
        totalFeeInWeiLow,
      );
      final totalFeeInETHAvg = await _abWeb3Network.convertBigIntToDecimal(
        totalFeeInWeiAvg,
      );
      final totalFeeInETHFast = await _abWeb3Network.convertBigIntToDecimal(
        totalFeeInWeiFast,
      );

      /// 计算转换成美元手的续费
      final totalFeeInUSDLow = totalFeeInETHLow * ethPriceInUsd;
      final totalFeeInUSDAvg = totalFeeInETHAvg * ethPriceInUsd;
      final totalFeeInUSDFast = totalFeeInETHFast * ethPriceInUsd;

      final symbol = await getSymbolByNetworkId(networkId);

      return ABWeb3EvmGasFeeLevel(
        isEIP1559: gasPriceModel.supportEip1559,
        low: ABWeb3EVMGasFeeImpl(
          networkId: networkId,
          baseFeeInWei: gasPriceModel.baseWeiFee,
          fee: totalFeeInETHLow,
          feeUSD: totalFeeInUSDLow,
          gasPriceInWei: gasPriceModel.lowPriWeiPerGas,
          symbol: symbol,
          time: gasPriceModel.lowPriCostTime,
          type: GasFeeType.low,
          gasLimit: BigInt.from(gasLimitFromBackend),
          coinPrice: ethPriceInUsd,
          isEIP1559: gasPriceModel.supportEip1559,
          maxFeePerGas: lowMaxFeePerGas,
        ),
        avg: ABWeb3EVMGasFeeImpl(
          networkId: networkId,
          baseFeeInWei: gasPriceModel.baseWeiFee,
          fee: totalFeeInETHAvg,
          feeUSD: totalFeeInUSDAvg,
          gasPriceInWei: gasPriceModel.avgPriWeiPerGas,
          symbol: symbol,
          time: gasPriceModel.avgPriCostTime,
          type: GasFeeType.avg,
          gasLimit: BigInt.from(gasLimitFromBackend),
          coinPrice: ethPriceInUsd,
          isEIP1559: gasPriceModel.supportEip1559,
          maxFeePerGas: avgMaxFeePerGas,
        ),
        fast: ABWeb3EVMGasFeeImpl(
          networkId: networkId,
          baseFeeInWei: gasPriceModel.baseWeiFee,
          fee: totalFeeInETHFast,
          feeUSD: totalFeeInUSDFast,
          gasPriceInWei: gasPriceModel.fastPriWeiPerGas,
          symbol: symbol,
          time: gasPriceModel.fastPriCostTime,
          type: GasFeeType.fast,
          gasLimit: BigInt.from(gasLimitFromBackend),
          coinPrice: ethPriceInUsd,
          isEIP1559: gasPriceModel.supportEip1559,
          maxFeePerGas: fastMaxFeePerGas,
        ),
      );
    } on GasServiceException catch (e) {
      if (e.code == GAS_SERVICE_EVM_NOT_SUPPORT_CHAIN) {
        return _getEvmGasByLocalRpc();
      }
      rethrow;
    }
  }

  Future<ABWeb3EvmGasFeeLevel> _getEvmGasByLocalRpc() async {
    final evmMethod =
        await (_abWeb3Network.network as ABWeb3EVMChainImpl).getRpcMethod();

    final supportEip1559 = await evmMethod.isSupportEIP1559();

    BigInt baseFee = BigInt.zero;
    late BigInt low;
    late BigInt avg;
    late BigInt fast;

    if (supportEip1559) {
      final eip1559Fee = await evmMethod.getGasInEip1559V2();
      baseFee = eip1559Fee.first.baseFee!;
      low = eip1559Fee[0].maxPriorityFeePerGas;
      avg = eip1559Fee[1].maxPriorityFeePerGas;
      fast = eip1559Fee[2].maxPriorityFeePerGas;
    } else {
      final gasPrice = await evmMethod.gasPrice();
      low = (Decimal.fromBigInt(gasPrice) * Decimal.parse("1.1")).toBigInt();
      avg = (Decimal.fromBigInt(gasPrice) * Decimal.parse("1.2")).toBigInt();
      fast = (Decimal.fromBigInt(gasPrice) * Decimal.parse("1.3")).toBigInt();
    }

    // final mainCoinSymbol = ABWeb3NetworkModule.instance
    //     .networkBy(networkId: networkId)
    //     ?.mainCoinSymbol;
    // final nativeConPriceBigDecimal = await YCApiMethod.getTokenFaitPrice(
    //   tokenName: mainCoinSymbol ?? '',
    //   chainName: networkId,
    //
    //   /// 方法一万倍获取更高精度
    //   number: '10000',
    // );

    final nativeConPriceBigDecimal = 0;

    /// 还原精度
    final nativeConPrice = nativeConPriceBigDecimal.toDouble() / 10000;

    /// 后端获取gasPrice和 gasLimit
    final gasPriceModel = EvmGasPriceModel(
      nativeCoinPrice: nativeConPrice.toString(),
      lowPriWeiPerGas: low,
      avgPriWeiPerGas: avg,
      fastPriWeiPerGas: fast,
      baseWeiFee: baseFee,
      supportEip1559: supportEip1559,
      lowPriCostTime: 60,
      avgPriCostTime: 30,
      fastPriCostTime: 15,
    );

    final l1GasFee = await _getL1Gas();

    final gasLimitFromBackend = await evmMethod.estimateGasV2(
      fromAddress: from,
      toAddress: to,
      data: data,
      value: value,
      gasPrice: gasPrice,
      maxFeePerGas: maxFeePerGas,
      maxPriorityFeePerGas: maxPriorityFeePerGas,
    );

    /// 获取币价
    final ethPriceInUsd = Decimal.parse(gasPriceModel.nativeCoinPrice);

    /// 计算总消耗的ETH，单位为wei
    final totalFeeInWeiLow =
        (gasPriceModel.lowPriWeiPerGas + gasPriceModel.baseWeiFee) *
            gasLimitFromBackend +
        l1GasFee;
    final totalFeeInWeiAvg =
        (gasPriceModel.avgPriWeiPerGas + gasPriceModel.baseWeiFee) *
            gasLimitFromBackend +
        l1GasFee;
    final totalFeeInWeiFast =
        (gasPriceModel.fastPriWeiPerGas + gasPriceModel.baseWeiFee) *
            gasLimitFromBackend +
        l1GasFee;

    /// 按照原油逻辑， maxFeePerGas 为 base+ priority 的1.5 倍
    final lowMaxFeePerGas = BigInt.from(
      1.5 *
          (gasPriceModel.lowPriWeiPerGas + gasPriceModel.baseWeiFee).toDouble(),
    );
    final avgMaxFeePerGas = BigInt.from(
      1.5 *
          (gasPriceModel.avgPriWeiPerGas + gasPriceModel.baseWeiFee).toDouble(),
    );
    final fastMaxFeePerGas = BigInt.from(
      1.5 *
          (gasPriceModel.fastPriWeiPerGas + gasPriceModel.baseWeiFee)
              .toDouble(),
    );

    final totalFeeInETHLow = await _abWeb3Network.convertBigIntToDecimal(
      totalFeeInWeiLow,
    );
    final totalFeeInETHAvg = await _abWeb3Network.convertBigIntToDecimal(
      totalFeeInWeiAvg,
    );
    final totalFeeInETHFast = await _abWeb3Network.convertBigIntToDecimal(
      totalFeeInWeiFast,
    );

    /// 计算转换成美元手的续费
    final totalFeeInUSDLow = totalFeeInETHLow * ethPriceInUsd;
    final totalFeeInUSDAvg = totalFeeInETHAvg * ethPriceInUsd;
    final totalFeeInUSDFast = totalFeeInETHFast * ethPriceInUsd;

    final symbol = await getSymbolByNetworkId(networkId);

    return ABWeb3EvmGasFeeLevel(
      isEIP1559: gasPriceModel.supportEip1559,
      low: ABWeb3EVMGasFeeImpl(
        networkId: networkId,
        baseFeeInWei: gasPriceModel.baseWeiFee,
        fee: totalFeeInETHLow,
        feeUSD: totalFeeInUSDLow,
        gasPriceInWei: gasPriceModel.lowPriWeiPerGas,
        symbol: symbol,
        time: gasPriceModel.lowPriCostTime,
        type: GasFeeType.low,
        gasLimit: gasLimitFromBackend,
        coinPrice: ethPriceInUsd,
        isEIP1559: gasPriceModel.supportEip1559,
        maxFeePerGas: lowMaxFeePerGas,
      ),
      avg: ABWeb3EVMGasFeeImpl(
        networkId: networkId,
        baseFeeInWei: gasPriceModel.baseWeiFee,
        fee: totalFeeInETHAvg,
        feeUSD: totalFeeInUSDAvg,
        gasPriceInWei: gasPriceModel.avgPriWeiPerGas,
        symbol: symbol,
        time: gasPriceModel.avgPriCostTime,
        type: GasFeeType.avg,
        gasLimit: gasLimitFromBackend,
        coinPrice: ethPriceInUsd,
        isEIP1559: gasPriceModel.supportEip1559,
        maxFeePerGas: avgMaxFeePerGas,
      ),
      fast: ABWeb3EVMGasFeeImpl(
        networkId: networkId,
        baseFeeInWei: gasPriceModel.baseWeiFee,
        fee: totalFeeInETHFast,
        feeUSD: totalFeeInUSDFast,
        gasPriceInWei: gasPriceModel.fastPriWeiPerGas,
        symbol: symbol,
        time: gasPriceModel.fastPriCostTime,
        type: GasFeeType.fast,
        gasLimit: gasLimitFromBackend,
        coinPrice: ethPriceInUsd,
        isEIP1559: gasPriceModel.supportEip1559,
        maxFeePerGas: fastMaxFeePerGas,
      ),
    );
  }

  @override
  Future<ABWeb3EVMTransaction?> selectGasFee() async {
    _gasLevelCache ??= await _getEvmGas();
    final gasSelected = await ABWeb3GasSelectorProviderManager.instance.provider
        .evm(
          fast: _gasLevelCache!.fast,
          average: _gasLevelCache!.avg,
          slow: _gasLevelCache!.low,
          isEIP1559: _gasLevelCache!.isEIP1559,
        );

    // 前端用户选择不为空则更新交易，否则保持原本选择
    if (gasSelected != null) {
      _updateTxGas(_gasLevelCache!.isEIP1559, gasSelected);
    } else {
      return null;
    }

    return this;
  }

  void _updateTxGas(bool isEIP1559, ABWeb3EVMGasFee evmGasFee) {
    if (isEIP1559) {
      final totalGas = evmGasFee.gasPriceInWei + evmGasFee.baseFeeInWei;

      /// 老逻辑 maxFee 是 1.5倍
      final maxFee = BigInt.from(1.5 * totalGas.toDouble());
      maxFeePerGas = maxFee;
      maxPriorityFeePerGas = evmGasFee.gasPriceInWei;
    } else {
      gasPrice = evmGasFee.gasPriceInWei;
    }
    gasLimit = evmGasFee.gasLimit;
  }

  Future<BigInt> _getL1Gas() async {
    return _abWeb3Network.network.getL1Gas(
      tx: data ?? Uint8List.fromList([]),
      networkId: networkId,
    );
  }

  @override
  Future<ABWeb3EVMGasFee> custom({
    required BigInt gasPrice,
    required ABWeb3EVMGasFee fromGasFee,
    BigInt? priorityFee,
    required BigInt gasLimit,
  }) {
    int newTime = fromGasFee.time;
    if (_gasLevelCache != null) {
      BigInt avgGasPrice =
          _gasLevelCache!.avg.baseFeeInWei + _gasLevelCache!.avg.gasPriceInWei;
      BigInt fastGasPrice =
          _gasLevelCache!.fast.baseFeeInWei +
          _gasLevelCache!.fast.gasPriceInWei;

      BigInt custom = gasPrice + (priorityFee ?? BigInt.zero);
      if (custom < avgGasPrice) {
        newTime = _gasLevelCache!.low.time;
      } else if (custom < fastGasPrice) {
        newTime = _gasLevelCache!.avg.time;
      } else {
        newTime = _gasLevelCache!.fast.time;
      }
    }
    return fromGasFee.custom(
      gasPrice: gasPrice,
      gasLimit: gasLimit,
      priorityFee: priorityFee,
      newTime: newTime,
    );
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

final class ABWeb3EVMUnsignedTransactionImpl
    extends ABWeb3EVMUnsignedTransaction {
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
