import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';
import 'dart:convert';

extension ABChainInfoExtension on ABChainInfo {
  static ABChainInfo fromJson(String jsonString) {
    // 将 JSON 字符串解析为 Map
    final json = jsonDecode(jsonString) as Map<String, dynamic>;

    // 解析嵌套的 ABTokenInfoAdapter
    final mainTokenInfo =
        json['mainTokenInfo'] != null
            ? ABTokenInfoAdapter(
              json['mainTokenInfo']['tokenSymbol'],
              json['mainTokenInfo']['tokenName'],
              json['mainTokenInfo']['tokenDecimals'],
              json['mainTokenInfo']['tokenLogo'],
              json['mainTokenInfo']['tokenType'],
              contractInfo:
                  json['mainTokenInfo']['contractInfo'] != null
                      ? ABContractInfoAdapter(
                        json['mainTokenInfo']['contractInfo']['contractAddress'] ??
                            '',
                      )
                      : null,
              ordinalsInfo:
                  json['mainTokenInfo']['ordinalsInfo'] != null
                      ? ABOridinalsInfoAdapter(
                        json['mainTokenInfo']['ordinalsInfo']['tick'] ?? '',
                      )
                      : null,
            )
            : null;

    // 解析嵌套的 ABChainEndpoints
    final endpoints =
        json['endpoints'] != null
            ? ABChainEndpoints(
              json['endpoints']['selectedEndpoints'],
              rpcAddresses: List<String>.from(
                json['endpoints']['rpcAddresses'] ?? const [],
              ),
              restfulAddresses: List<String>.from(
                json['endpoints']['restfulAddresses'] ?? const [],
              ),
              graphqlAddresses: List<String>.from(
                json['endpoints']['graphqlAddresses'] ?? const [],
              ),
              grpcAddresses: List<String>.from(
                json['endpoints']['grpcAddresses'] ?? const [],
              ),
              wssAddresses: List<String>.from(
                json['endpoints']['wssAddresses'] ?? const [],
              ),
            )
            : null;

    // 返回 ABChainInfo 实例
    return ABChainInfo(
      json['chainId'],
      json['walletCoreCoinType'],
      json['chainName'],
      json['chainType'],
      json['networkType'],
      json['chainLogo'],
      json['derivationPath'],
      endpoints: endpoints,
      mainTokenInfo: mainTokenInfo,
      evmChainId: json['evmChainId'],
    );
  }

  /// 将 ABChainInfo 对象转换为 JSON 字符串
  String toJson() {
    // 转换 mainTokenInfo 为 JSON
    final mainTokenInfoJson =
        mainTokenInfo != null
            ? {
              'tokenSymbol': mainTokenInfo!.tokenSymbol,
              'tokenName': mainTokenInfo!.tokenName,
              'tokenDecimals': mainTokenInfo!.tokenDecimals,
              'tokenLogo': mainTokenInfo!.tokenLogo,
              'tokenType': mainTokenInfo!.tokenType,
              'contractInfo':
                  mainTokenInfo!.contractInfo != null
                      ? {
                        'contractAddress':
                            mainTokenInfo!.contractInfo!.contractAddress,
                      }
                      : null,
              'ordinalsInfo':
                  mainTokenInfo!.ordinalsInfo != null
                      ? {'tick': mainTokenInfo!.ordinalsInfo!.tick}
                      : null,
            }
            : null;

    final endpointsJson =
        endpoints != null
            ? {
              'selectedEndpoints': endpoints!.selectedEndpoints,
              'rpcAddresses': endpoints!.rpcAddresses.toList(),
              'restfulAddresses': endpoints!.restfulAddresses.toList(),
              'graphqlAddresses': endpoints!.graphqlAddresses.toList(),
              'grpcAddresses': endpoints!.grpcAddresses.toList(),
              'wssAddresses': endpoints!.wssAddresses.toList(),
            }
            : null;

    final json = {
      'chainId': chainId,
      'walletCoreCoinType': walletCoreCoinType,
      'chainName': chainName,
      'chainType': chainType,
      'networkType': networkType,
      'chainLogo': chainLogo,
      'derivationPath': derivationPath,
      'endpoints': endpointsJson,
      'mainTokenInfo': mainTokenInfoJson,
      'evmChainId': evmChainId,
    };

    return jsonEncode(json);
  }
}
