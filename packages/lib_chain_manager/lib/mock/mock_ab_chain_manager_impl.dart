import 'package:lib_chain_manager/interface/ab_chain_manager_interface.dart';
import 'package:lib_chain_manager/model/ab_chain_endpoints.dart';
import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_chain_manager/model/ab_chain_type.dart';
import 'package:lib_chain_manager/model/ab_network_type.dart';
import 'package:lib_token_manager/lib_token_manager.dart';

class MockAbChainManagerImpl extends ABChainManagerInterface {
  MockAbChainManagerImpl._internal();

  static final MockAbChainManagerImpl instance =
      MockAbChainManagerImpl._internal();

  factory MockAbChainManagerImpl() {
    return instance;
  }

  ///用于临时缓存
  static final List<ABChainInfo> networkInfoList = [];

  @override
  Future<List<ABChainInfo>> getAllChainInfos() {
    var eth = ABChainInfo(
      chainId: 1,
      walletCoreCoinType: 60,
      chainName: 'Ethereum',
      chainType: ABChainType.ehtereum,
      networkType: ABNetworkType.mainnet,
      chainLogo: 'ethereum',
      endpoints: ABChainEndpoints(rpcAddresses: ["https://eth.merkle.io"]),
      derivationPath: 'm/44\'/60\'/0\'/0',
      evmChainId: 1,
      mainTokenInfo: ABTokenInfo(
        tokenName: 'ETH',
        tokenSymbol: 'ETH',
        tokenDecimals: 18,
        tokenLogo: "",
        tokenType: ABTokenType.mainToken,
      ),
    );
    var ethTest = ABChainInfo(
      chainId: 2,
      walletCoreCoinType: 60,
      chainName: 'Sepolia',
      chainType: ABChainType.ehtereum,
      networkType: ABNetworkType.testnet,
      chainLogo: 'ethereum',
      endpoints: ABChainEndpoints(
        rpcAddresses: [
          "https://blockchain.googleapis.com/v1/projects/gtwallet/locations/us-central1/endpoints/ethereum-sepolia/rpc?key=AIzaSyBPMN5sAeK7v5PODpz_cRG98lrdEAGZ_yQ",
        ],
      ),
      derivationPath: 'm/44\'/60\'/0\'/0',
      evmChainId: 11155111,
      mainTokenInfo: ABTokenInfo(
        tokenName: 'ETH',
        tokenSymbol: 'SepoliaETH',
        tokenDecimals: 18,
        tokenLogo: "",
        tokenType: ABTokenType.mainToken,
      ),
    );
    var newchain = ABChainInfo(
      chainId: 2,
      walletCoreCoinType: 1642,
      chainName: 'NewChain',
      chainType: ABChainType.other,
      networkType: ABNetworkType.mainnet,
      chainLogo: 'newlogo',
      endpoints: ABChainEndpoints(rpcAddresses: [""]),
      derivationPath: 'm/44\'/1642\'/0\'/0',
      mainTokenInfo: ABTokenInfo(
        tokenName: 'AB',
        tokenSymbol: 'AB',
        tokenDecimals: 18,
        tokenLogo: "",
        tokenType: ABTokenType.mainToken,
      ),
    );
    List<ABChainInfo> chains = [];
    var chainNums = 1000;
    for (int i = 0; i < chainNums; i++) {
      var newchain = ABChainInfo(
        chainId: i,
        walletCoreCoinType: 1642,
        chainName: 'NewChain',
        chainType: ABChainType.other,
        networkType: ABNetworkType.mainnet,
        chainLogo: 'newlogo',
        endpoints: ABChainEndpoints(rpcAddresses: [""]),
        derivationPath: 'm/44\'/1642\'/0\'/0',
        mainTokenInfo: ABTokenInfo(
          tokenName: 'AB',
          tokenSymbol: 'AB',
          tokenDecimals: 18,
          tokenLogo: "",
          tokenType: ABTokenType.mainToken,
        ),
      );
      chains.add(newchain);
    }
    networkInfoList.clear();
    networkInfoList.add(eth);
    networkInfoList.add(ethTest);
    networkInfoList.add(newchain);
    networkInfoList.addAll(chains);
    return Future.value([eth, ethTest, newchain]);
  }

  @override
  Future<ABChainInfo?> getDAppSelectedChainInfo() {
    // TODO: implement getDAppSelectedChainInfo
    throw UnimplementedError();
  }

  @override
  Future<ABChainInfo?> getSelectedChainInfo() {
    // TODO: implement getSelectedChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> setDAppSelectedChainInfo(ABChainInfo info) {
    // TODO: implement setDAppSelectedChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> setSelectedChainInfo(ABChainInfo info) {
    // TODO: implement setSelectedChainInfo
    throw UnimplementedError();
  }

  @override
  List<ABChainInfo> getCacheAllChainInfos() {
    if (networkInfoList.isNotEmpty) {
      return networkInfoList;
    } else {
      //TODO: 返回本地那份 此处为模拟代码
      getAllChainInfos();
      return networkInfoList;
    }
  }

  ///通过chainId查询网络信息
  ABChainInfo? getChainInfoByChainId(int chainId) {
    //TODO: 看是否需要将该方法加入ABChainManagerInterface中
    for (var chainInfo in networkInfoList) {
      if (chainId == chainInfo.chainId) {
        return chainInfo;
      }
    }
    return null;
  }
}
