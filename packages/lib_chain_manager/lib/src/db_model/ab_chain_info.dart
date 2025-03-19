import 'package:realm/realm.dart';
part 'ab_chain_info.realm.dart';

@RealmModel()
class _ABChainInfo {
  /// chain info id
  @PrimaryKey()
  late int chainId;

  /// only for use walle core
  late int walletCoreCoinType;

  /// chain name;
  late String chainName;

  /// chain type; 什么系列的链，比如 btc，evm 等
  // late ABChainType chainType;
  late String chainType;

  /// network type, 区分主网，测试网，自定义网络等
  // late ABNetworkType networkType;
  late String networkType;

  /// chain logo; 默认值自动根据名称生成
  late String chainLogo;

  /// chain endpoints;
  late _ABChainEndpoints? endpoints;

  /// chain derivation path;
  late String derivationPath;

  /// main token info;
  late _ABTokenInfoAdapter? mainTokenInfo;

  int? evmChainId;

  // ABChainInfo({
  //   required this.chainId,
  //   required this.walletCoreCoinType,
  //   required this.chainName,
  //   required this.chainType,
  //   required this.networkType,
  //   required this.chainLogo,
  //   required this.endpoints,
  //   required this.derivationPath,
  //   required this.mainTokenInfo,
  //   this.evmChainId,
  // });
  //
  // toJson() {
  //   return {
  //     'chainId': chainId,
  //     'walletCoreCoinType': walletCoreCoinType,
  //     'chainName': chainName,
  //     'chainType': chainType.blockchainIndex,
  //     'networkType': networkType.networkIndex,
  //     'chainLogo': chainLogo,
  //     'endpoints': endpoints.toJson(),
  //     'derivationPath': derivationPath,
  //     'mainTokenInfo': mainTokenInfo.toJson(),
  //     'evmChainId': evmChainId,
  //   };
  // }
  //
  // factory ABChainInfo.fromJson(Map<String, dynamic> json) {
  //   return ABChainInfo(
  //     chainId: json['chainId'],
  //     walletCoreCoinType: json['walletCoreCoinType'],
  //     chainName: json['chainName'],
  //     chainType: ABChainType.fromIndex(json['chainType']),
  //     networkType: ABNetworkType.fromIndex(json['networkType']),
  //     chainLogo: json['chainLogo'],
  //     endpoints: ABChainEndpoints.fromJson(json['endpoints']),
  //     derivationPath: json['derivationPath'],
  //     mainTokenInfo: ABTokenInfo.fromJson(json['mainTokenInfo']),
  //     evmChainId: json['evmChainId'],
  //   );
  // }
}

@RealmModel()
class _ABChainEndpoints {
  /// chain rpc addresses
  late List<String> rpcAddresses;

  /// chain restful addresses;
  late List<String> restfulAddresses;

  /// chain graphql addresses;
  late List<String> graphqlAddresses;

  /// chain grpc addresses;
  late List<String> grpcAddresses;

  /// chain wss enedpoints
  late List<String> wssAddresses;

  late String selectedEndpoints;

/// ABChainEndpoints constructs;
// ABChainEndpoints({
//   this.rpcAddresses,
//   this.restfulAddresses,
//   this.graphqlAddresses,
//   this.grpcAddresses,
//   this.wssAddresses,
//   this.selectedEndpoints,
// });

// @override
// String toString() {
//   return 'ABChainEndpoints{rpcAddresses: $rpcAddresses, restfulAddresses: $restfulAddresses, graphqlAddresses: $graphqlAddresses, grpcAddresses: $grpcAddresses, wssAddresses: $wssAddresses}';
// }
//
// toJson() {
//   return {
//     'rpcAddresses': rpcAddresses,
//     'restfulAddresses': restfulAddresses,
//     'graphqlAddresses': graphqlAddresses,
//     'grpcAddresses': grpcAddresses,
//     'wssAddresses': wssAddresses,
//     'selectedEndpoints': selectedEndpoints,
//   };
// }
//
// factory ABChainEndpoints.fromJson(Map<String, dynamic> json) {
//   return ABChainEndpoints(
//     rpcAddresses:
//         json['rpcAddresses'] == null ? null : (json['rpcAddresses'] as List).map((e) => e as String).toList(),
//     restfulAddresses:
//         json['restfulAddresses'] == null
//             ? null
//             : (json['restfulAddresses'] as List)?.map((e) => e as String).toList(),
//     graphqlAddresses:
//         json['graphqlAddresses'] == null
//             ? null
//             : (json['graphqlAddresses'] as List)?.map((e) => e as String).toList(),
//     grpcAddresses:
//         json['grpcAddresses'] == null ? null : (json['grpcAddresses'] as List)?.map((e) => e as String).toList(),
//     wssAddresses:
//         json['wssAddresses'] == null ? null : (json['wssAddresses'] as List)?.map((e) => e as String).toList(),
//     selectedEndpoints: json['selectedEndpoints'] == null ? null : (json['selectedEndpoints'] as String),
//   );
// }
}


/// This is the wrapper class for _ABTokenInfo and needs to stay consistent with its attributes.
@RealmModel()
class _ABTokenInfoAdapter {
  late String tokenSymbol;

  late String tokenName;

  late int tokenDecimals;

  late String tokenLogo;

  // late ABTokenType tokenType;
  late String tokenType;

  // 合约类型信息
  _ABContractInfoAdapter? contractInfo;

  // 铭文类型基础信息
  _ABOridinalsInfoAdapter? ordinalsInfo;
}

@RealmModel()
class _ABContractInfoAdapter {
  late String contractAddress;
}

@RealmModel()
class _ABOridinalsInfoAdapter  {
  late String tick;
}

