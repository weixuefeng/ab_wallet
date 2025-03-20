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

  /// chain explorer addresses
  late String explorerAddresses;
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

