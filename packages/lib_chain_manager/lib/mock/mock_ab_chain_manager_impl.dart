import 'package:lib_chain_manager/interface/ab_chain_manager_interface.dart';
import 'package:lib_chain_manager/model/ab_chain_endpoints.dart';
import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_chain_manager/model/ab_chain_type.dart';
import 'package:lib_chain_manager/model/ab_network_type.dart';
import 'package:lib_token_manager/lib_token_manager.dart';

class MockAbChainManagerImpl extends ABChainManagerInterface {
  MockAbChainManagerImpl._internal();

  static final MockAbChainManagerImpl instance = MockAbChainManagerImpl._internal();

  factory MockAbChainManagerImpl() {
    return instance;
  }

  @override
  Future<List<ABChainInfo>> getAllChainInfos() {
    var eth = ABChainInfo(
      chainId: 1,
      walletCoreCoinType: 60,
      chainName: 'Ethereum',
      chainType: ABChainType.ehtereum,
      networkType: ABNetworkType.mainnet,
      chainLogo: 'ethereum',
      endpoints: ABChainEndpoints(rpcAddresses: [""]),
      derivationPath: 'm/44\'/60\'/0\'/0',
      mainTokenInfo: ABTokenInfo(
        tokenName: 'ETH',
        tokenSymbol: 'ETH',
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
    return Future.value([eth, newchain]);
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
}
