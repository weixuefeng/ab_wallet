import 'package:lib_chain_manager/src/db_model/ab_chain_info.dart';
import 'package:lib_token_manager/lib_token_manager.dart';

extension ABTokenInfoAdapterExtension on ABTokenInfoAdapter {
  // change ABTokenInfo to ABTokenInfoAdapter
  static ABTokenInfoAdapter fromABTokenInfo(ABTokenInfo tokenInfo) {
    var contractInfoAdapter = ABContractInfoAdapter(
      tokenInfo.contractInfo == null
          ? ""
          : tokenInfo.contractInfo!.contractAddress,
    );
    var oridinalsInfoAdapter = ABOridinalsInfoAdapter(
      tokenInfo.ordinalsInfo == null ? "" : tokenInfo.ordinalsInfo!.tick,
    );
    return ABTokenInfoAdapter(
      tokenInfo.tokenSymbol,
      tokenInfo.tokenName,
      tokenInfo.tokenDecimals,
      tokenInfo.tokenLogo,
      tokenInfo.tokenType,
      contractInfo: contractInfoAdapter,
      ordinalsInfo: oridinalsInfoAdapter,
    );
  }

  // change ABTokenInfoAdapter to ABTokenInfo
  ABTokenInfo toABTokenInfo() {
    var contract = ABContractInfo(
      contractInfo == null ? '' : contractInfo!.contractAddress,
    );
    var ordinals = ABOridinalsInfo(
      ordinalsInfo == null ? '' : ordinalsInfo!.tick,
    );

    return ABTokenInfo(
      tokenSymbol,
      tokenName,
      tokenDecimals,
      tokenLogo,
      tokenType,
      contractInfo: contract,
      ordinalsInfo: ordinals,
    );
  }
}
