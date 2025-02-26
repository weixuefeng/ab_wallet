enum ABNetworkType {
  mainnet('mainnet', 0),
  testnet('testnet', 1),
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
