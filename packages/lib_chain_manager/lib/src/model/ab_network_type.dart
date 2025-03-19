enum ABNetworkType {
  // 主网络由后台控制
  mainnet('mainnet', 0),
  // 测试网络由后台控制
  testnet('testnet', 1),
  // 自定义网络由用户控制（自定义主网和测试网均属于自定义网络）
  custom('custom', 2);

  final String networkName;
  final int networkIndex;

  const ABNetworkType(this.networkName, this.networkIndex);

  static ABNetworkType fromIndex(int index) {
    switch (index) {
      case 0:
        return ABNetworkType.mainnet;
      case 1:
        return ABNetworkType.testnet;
      case 2:
        return ABNetworkType.custom;
      default:
        throw 'Unknown network index: $index';
    }
  }
}
