import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';
import 'package:lib_chain_manager/src/interface/ab_chain_manager_interface.dart';
import 'package:lib_chain_manager/src/model/ab_chain_type.dart';
import 'package:lib_chain_manager/src/model/ab_network_type.dart';
import 'package:lib_token_manager/lib_token_manager.dart';
import 'package:realm/realm.dart';

class MockAbChainManagerImpl extends ABChainManagerInterface {
  late final LocalConfiguration _chainDBInfoConfig;

  MockAbChainManagerImpl._internal() {
    _chainDBInfoConfig = Configuration.local([
      ABChainInfo.schema,
      ABChainEndpoints.schema,
      ABTokenInfoAdapter.schema,
      ABContractInfoAdapter.schema,
      ABOridinalsInfoAdapter.schema,
    ], schemaVersion: 0);
  }

  static final MockAbChainManagerImpl instance =
      MockAbChainManagerImpl._internal();

  factory MockAbChainManagerImpl() {
    return instance;
  }

  @override
  Future<List<ABChainInfo>> getAllChainInfos() async {
    // 1:get cache chainInfos from dataStorage;
    var realm = Realm(_chainDBInfoConfig);
    var chainDBInfos = realm.all<ABChainInfo>().toList();
    realm.close();
    if (chainDBInfos.isNotEmpty) {
      return Future.value(chainDBInfos);
    }
    // 2: get data from net
    List<ABChainInfo> networkInfoList = [];

    var eth = ABChainInfo(
      1,
      60,
      'Ethereum',
      ABChainType.ehtereum.name,
      ABNetworkType.mainnet.name,
      'ethereum',
      endpoints: ABChainEndpoints(
        "https://eth.merkle.io",
        '',
        rpcAddresses: ["https://eth.merkle.io"],
      ),
      'm/44\'/60\'/0\'/0',
      evmChainId: 1,
      mainTokenInfo: ABTokenInfoAdapter(
        'ETH',
        'ETH',
        18,
        "",
        ABTokenType.mainToken.name,
      ),
    );

    var newchain = ABChainInfo(
      3,
      1642,
      'NewChain',
      ABChainType.newchain.name,
      ABNetworkType.mainnet.name,
      'newlogo',
      endpoints: ABChainEndpoints("", '', rpcAddresses: [""]),
      'm/44\'/1642\'/0\'/0',
      mainTokenInfo: ABTokenInfoAdapter(
        'AB',
        'AB',
        18,
        "",
        ABTokenType.mainToken.name,
      ),
      evmChainId: null,
    );
    var ab = ABChainInfo(
      4,
      60,
      'ABCore',
      ABChainType.ehtereum.name,
      ABNetworkType.testnet.name,
      'newlogo',
      endpoints: ABChainEndpoints(
        "https://rpc.core.testnet.ab.org",
        '',
        rpcAddresses: ["https://rpc.core.testnet.ab.org"],
      ),
      'm/44\'/60\'/0\'/0',
      mainTokenInfo: ABTokenInfoAdapter(
        'AB',
        'AB',
        18,
        "",
        ABTokenType.mainToken.name,
      ),
      evmChainId: 26888,
    );
    networkInfoList.add(eth);
    networkInfoList.add(newchain);
    networkInfoList.add(ab);
    if (networkInfoList.isNotEmpty) {
      return Future.value(networkInfoList);
    }

    // 3: default chains info
    return Future.value(networkInfoList);
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

  ///通过chainId查询网络信息
  Future<ABChainInfo?> getChainInfoByChainId(int chainId) async {
    List<ABChainInfo> networkInfoList = await getAllChainInfos();
    for (var chainInfo in networkInfoList) {
      if (chainId == chainInfo.chainId) {
        return chainInfo;
      }
    }
    return null;
  }

  @override
  Future<bool> updateChainInfo(ABChainInfo info) {
    // TODO: implement updateChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> addChainInfo(ABChainInfo info) {
    // TODO: implement addChainInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteChainInfo(ABChainInfo info) async {
    var realm = Realm(_chainDBInfoConfig);
    try {
      realm.write(() {
        final chainToDelete = realm.all<ABChainInfo>().firstWhere(
          (chain) => chain.chainId == info,
        );
        realm.delete(chainToDelete);
      });
      return true;
    } catch (e) {
      ABLogger.e('Error delete chain info: $e');
      return false;
    } finally {
      realm.close();
    }
  }

  @override
  Future<bool> updateChainInfoFromNet(List<ABChainInfo> info) async {
    var realm = Realm(_chainDBInfoConfig);
    try {
      realm.write(() {
        final chainsToDelete = realm.all<ABChainInfo>().where(
          (chain) =>
              chain.networkType == ABNetworkType.mainnet.name ||
              chain.networkType == ABNetworkType.testnet.name,
        );
        realm.deleteMany(chainsToDelete);
        for (var chain in info) {
          realm.add(chain, update: true);
        }
      });
      return true;
    } catch (e) {
      ABLogger.e('Error updating chain info from net: $e');
      return false;
    } finally {
      realm.close();
    }
  }
}
