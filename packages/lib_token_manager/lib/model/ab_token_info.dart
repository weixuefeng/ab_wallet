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
}
