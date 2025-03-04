import 'package:lib_chain_manager/model/ab_chain_endpoints.dart';
import 'package:lib_chain_manager/model/ab_chain_type.dart';
import 'package:lib_chain_manager/model/ab_network_type.dart';
import 'package:lib_token_manager/lib_token_manager.dart';

class ABChainInfo {
  /// chain info id
  late int chainId;

  /// only for use walle core
  late int walletCoreCoinType;

  /// chain name;
  late String chainName;

  /// chain type; 什么系列的链，比如 btc，evm 等
  late ABChainType chainType;

  /// network type, 区分主网，测试网，自定义网络等
  late ABNetworkType networkType;

  /// chain logo; 默认值自动根据名称生成
  late String chainLogo;

  /// chain endpoints;
  late ABChainEndpoints endpoints;

  /// chain derivation path;
  late String derivationPath;

  /// main token info;
  late ABTokenInfo mainTokenInfo;

  int? evmChainId;

  ABChainInfo({
    required this.chainId,
    required this.walletCoreCoinType,
    required this.chainName,
    required this.chainType,
    required this.networkType,
    required this.chainLogo,
    required this.endpoints,
    required this.derivationPath,
    required this.mainTokenInfo,
    this.evmChainId,
  });

  toJson() {
    return {
      'chainId': chainId,
      'walletCoreCoinType': walletCoreCoinType,
      'chainName': chainName,
      'chainType': chainType.blockchainIndex,
      'networkType': networkType.networkIndex,
      'chainLogo': chainLogo,
      'endpoints': endpoints.toJson(),
      'derivationPath': derivationPath,
      'mainTokenInfo': mainTokenInfo.toJson(),
      'evmChainId': evmChainId,
    };
  }

  factory ABChainInfo.fromJson(Map<String, dynamic> json) {
    return ABChainInfo(
      chainId: json['chainId'],
      walletCoreCoinType: json['walletCoreCoinType'],
      chainName: json['chainName'],
      chainType: ABChainType.fromIndex(json['chainType']),
      networkType: ABNetworkType.fromIndex(json['networkType']),
      chainLogo: json['chainLogo'],
      endpoints: ABChainEndpoints.fromJson(json['endpoints']),
      derivationPath: json['derivationPath'],
      mainTokenInfo: ABTokenInfo.fromJson(json['mainTokenInfo']),
      evmChainId: json['evmChainId'],
    );
  }
}
