import 'package:lib_token_manager/model/ab_contract_info.dart';
import 'package:lib_token_manager/model/ab_ordinals_info.dart';
import 'package:lib_token_manager/model/ab_token_type.dart';

class ABTokenInfo {
  late String tokenSymbol;

  late String tokenName;

  late int tokenDecimals;

  late String tokenLogo;

  late ABTokenType tokenType;

  // 合约类型信息
  ABContractInfo? contractInfo;

  // 铭文类型基础信息
  ABOridinalsInfo? ordinalsInfo;

  ABTokenInfo({
    required this.tokenSymbol,
    required this.tokenName,
    required this.tokenDecimals,
    required this.tokenLogo,
    required this.tokenType,
    this.contractInfo,
    this.ordinalsInfo,
  });

  toJson() {
    return {
      'tokenSymbol': tokenSymbol,
      'tokenName': tokenName,
      'tokenDecimals': tokenDecimals,
      'tokenLogo': tokenLogo,
      'tokenType': tokenType.protocolIndex,
      'contractInfo': contractInfo?.toJson(),
      'ordinalsInfo': ordinalsInfo?.toJson(),
    };
  }

  factory ABTokenInfo.fromJson(Map<String, dynamic> json) {
    return ABTokenInfo(
      tokenSymbol: json['tokenSymbol'],
      tokenName: json['tokenName'],
      tokenDecimals: json['tokenDecimals'],
      tokenLogo: json['tokenLogo'],
      tokenType: ABTokenType.fromIndex(json['tokenType']),
      contractInfo: json['contractInfo'] != null ? ABContractInfo.fromJson(json['contractInfo']) : null,
      ordinalsInfo: json['ordinalsInfo'] != null ? ABOridinalsInfo.fromJson(json['ordinalsInfo']) : null,
    );
  }
}
