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
}
