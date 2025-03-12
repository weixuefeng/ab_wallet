
/// 通过networkKey获取网络名称
Future<String> getNameByNetworkId(int networkId) async {
  try {
    // var networkInfo = ABWeb3NetworkModule.instance.networkBy(networkId: networkId);
    // if (networkInfo == null) {
    //   throw ('can not found networkInfo of $networkKey');
    // }
    // return networkInfo.displayName;
    return "AB";
  } catch (e) {
    throw ('can not found network name of $networkId, error: $e');
  }
}

/// 通过networkKey获取网络主代币Symbol
Future<String> getSymbolByNetworkId(int networkId) async {
  try {
    // var networkInfo = ABWeb3NetworkModule.instance.networkBy(networkId: networkId);
    // if (networkInfo == null) {
    //   Log.d('can not found networkInfo of $networkId');
    //   throw ('can not found networkInfo of $networkId');
    // }
    // return networkInfo.mainCoinSymbol;
    return "AB";
  } catch (e) {
    throw ('can not found network symbol of $networkId, error: $e');
  }
}
