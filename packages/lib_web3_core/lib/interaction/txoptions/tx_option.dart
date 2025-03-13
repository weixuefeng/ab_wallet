abstract class ABWeb3ChainBuildTxOptions {
  const ABWeb3ChainBuildTxOptions();

  /// TON网络构建交易参数
  static ABWebChainBuildTonTxOptions ton({int? sendMode}) => ABWebChainBuildTonTxOptions(sendMode: sendMode);
  ABWebChainBuildTonTxOptions get asTon => this as ABWebChainBuildTonTxOptions;

  /// SUI网络构建交易参数
  static ABWeb3ChainBuildSuiTxOptions sui({required BigInt gas}) => ABWeb3ChainBuildSuiTxOptions(gas: gas);
  ABWeb3ChainBuildSuiTxOptions get asSui => this as ABWeb3ChainBuildSuiTxOptions;

  /// EVM网络构建交易参数
  static ABWeb3ChainBuildEVMTxOptions evm({bool? isEnablingEIP1559}) =>
      ABWeb3ChainBuildEVMTxOptions(isEnablingEIP1559: isEnablingEIP1559);
  ABWeb3ChainBuildEVMTxOptions? get asEvm =>
      this is ABWeb3ChainBuildEVMTxOptions ? this as ABWeb3ChainBuildEVMTxOptions : null;

  /// TRX网络构建交易参数
  static ABWeb3ChainBuildTRXTxOptions trx({required int energyUsed}) =>
      ABWeb3ChainBuildTRXTxOptions(energyUsed: energyUsed);
  ABWeb3ChainBuildTRXTxOptions get asTrx => this as ABWeb3ChainBuildTRXTxOptions;
}

final class ABWebChainBuildTonTxOptions extends ABWeb3ChainBuildTxOptions {
  /// 发送模式
  final int? sendMode;

  ABWebChainBuildTonTxOptions({this.sendMode});
}

final class ABWeb3ChainBuildSuiTxOptions extends ABWeb3ChainBuildTxOptions {
  /// 手续费
  final BigInt gas;

  ABWeb3ChainBuildSuiTxOptions({required this.gas});
}

final class ABWeb3ChainBuildEVMTxOptions extends ABWeb3ChainBuildTxOptions {
  /// 是否启用EIP-1559
  final bool? isEnablingEIP1559;

  ABWeb3ChainBuildEVMTxOptions({this.isEnablingEIP1559});
}

final class ABWeb3ChainBuildTRXTxOptions extends ABWeb3ChainBuildTxOptions {
  /// 能量消耗
  final int? energyUsed;

  ABWeb3ChainBuildTRXTxOptions({required this.energyUsed});
}
