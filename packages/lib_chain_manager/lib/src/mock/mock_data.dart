import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';
import 'package:lib_chain_manager/src/model/ab_chain_type.dart';
import 'package:lib_chain_manager/src/model/ab_network_type.dart';
import 'package:lib_token_manager/lib_token_manager.dart';

List<ABChainInfo> chainFallbackList = [
  ABChainInfo(
    1, //chainId
    60, //walletCoreCoinType
    'Ethereum', //chainName
    ABChainType.ehtereum.name, //chainType
    ABNetworkType.mainnet.name, //networkType
    '', //chainLogo
    'm/44\'/60\'/0\'/0', //derivationPath
    endpoints: ABChainEndpoints(
      'https://eth.merkle.io',
      'https://etherscan.io',
      rpcAddresses: ['https://eth.merkle.io'],
    ),
    mainTokenInfo: ABTokenInfoAdapter(
      'ETH',//tokenSymbol
      'ETH',//tokenName
      18,//tokenDecimals
      '',//tokenLogo
      ABTokenType.mainToken.name,//tokenType
    ),
    evmChainId: 1
  ),
  ABChainInfo(
    3,
    1642,
    'NewChain',
    ABChainType.newchain.name,
    ABNetworkType.mainnet.name,
    '',
    endpoints: ABChainEndpoints('https://jp.rpc.mainnet.newtonproject.org',
        'https://explorer.newtonproject.org',
        rpcAddresses: ['https://jp.rpc.mainnet.newtonproject.org']),
    'm/44\'/1642\'/0\'/0',
    mainTokenInfo: ABTokenInfoAdapter(
      'AB',
      'AB',
      18,
      '',
      ABTokenType.mainToken.name,
    ),
    evmChainId: null,
  ),
  ABChainInfo(
    4,
    60,
    'ABCore',
    ABChainType.ehtereum.name,
    ABNetworkType.testnet.name,
    '',
    endpoints: ABChainEndpoints(
      'https://rpc.core.testnet.ab.org',
      '',
      rpcAddresses: ['https://rpc.core.testnet.ab.org'],
    ),
    'm/44\'/60\'/0\'/0',
    mainTokenInfo: ABTokenInfoAdapter(
      'AB',
      'AB',
      18,
      '',
      ABTokenType.mainToken.name,
    ),
    evmChainId: 26888,
  ),
  ABChainInfo(
    5,
    501,
    'Solana',
    ABChainType.solana.name,
    ABNetworkType.mainnet.name,
    '',
    endpoints: ABChainEndpoints(
      'https://api.mainnet-beta.solana.com',
      'https://explorer.solana.com',
      rpcAddresses: ['https://api.mainnet-beta.solana.com'],
    ),
    'm/0\'/0\'',
    mainTokenInfo: ABTokenInfoAdapter(
      'SOL',
      'SOL',
      9,
      "",
      ABTokenType.mainToken.name,
    ),
    evmChainId: null,
  )
];
