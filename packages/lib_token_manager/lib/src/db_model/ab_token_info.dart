import 'package:realm/realm.dart';

part 'ab_token_info.realm.dart';

@RealmModel()
class _ABTokenInfo {
  late String tokenSymbol;

  late String tokenName;

  late int tokenDecimals;

  late String tokenLogo;

  // late ABTokenType tokenType;
  late String tokenType;

  // 合约类型信息
  _ABContractInfo? contractInfo;

  // 铭文类型基础信息
  _ABOridinalsInfo? ordinalsInfo;

  // ABTokenInfo({
  //   required this.tokenSymbol,
  //   required this.tokenName,
  //   required this.tokenDecimals,
  //   required this.tokenLogo,
  //   required this.tokenType,
  //   this.contractInfo,
  //   this.ordinalsInfo,
  // });

  // toJson() {
  //   return {
  //     'tokenSymbol': tokenSymbol,
  //     'tokenName': tokenName,
  //     'tokenDecimals': tokenDecimals,
  //     'tokenLogo': tokenLogo,
  //     'tokenType': tokenType.protocolIndex,
  //     'contractInfo': contractInfo?.toJson(),
  //     'ordinalsInfo': ordinalsInfo?.toJson(),
  //   };
  // }

  // factory ABTokenInfo.fromJson(Map<String, dynamic> json) {
  //   return ABTokenInfo(
  //     tokenSymbol: json['tokenSymbol'],
  //     tokenName: json['tokenName'],
  //     tokenDecimals: json['tokenDecimals'],
  //     tokenLogo: json['tokenLogo'],
  //     tokenType: ABTokenType.fromIndex(json['tokenType']),
  //     contractInfo: json['contractInfo'] != null ? ABContractInfo.fromJson(json['contractInfo']) : null,
  //     ordinalsInfo: json['ordinalsInfo'] != null ? ABOridinalsInfo.fromJson(json['ordinalsInfo']) : null,
  //   );
  // }
}

@RealmModel()
class _ABContractInfo {
  late String contractAddress;

// ABContractInfo({required this.contractAddress});
//
// toJson() {
//   return {'contractAddress': contractAddress};
// }
//
// factory ABContractInfo.fromJson(Map<String, dynamic> json) {
//   return ABContractInfo(contractAddress: json['contractAddress']);
// }
}

@RealmModel()
class _ABOridinalsInfo {
  late String tick;

// ABOridinalsInfo({required this.tick});
//
// toJson() {
//   return {'tick': tick};
// }
//
// factory ABOridinalsInfo.fromJson(Map<String, dynamic> json) {
//   return ABOridinalsInfo(tick: json['tick']);
// }
}
