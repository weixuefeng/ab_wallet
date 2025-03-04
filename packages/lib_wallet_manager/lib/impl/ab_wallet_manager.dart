import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_storage/ab_storage_kv.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_storage.dart';
import 'package:lib_wallet_manager/interface/ab_wallet_manager_interface.dart';
import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_account_detail.dart';
import 'package:lib_wallet_manager/model/ab_protocol_account.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';
import 'package:lib_wallet_manager/model/ab_wallet_type.dart';
import 'package:lib_web3_core/impl/wallet_method_impl.dart';
import 'package:lib_web3_core/model/wallet_account_model.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';

class AbWalletManager extends ABWalletManagerInterface {
  AbWalletManager._internal();

  static final AbWalletManager instance = AbWalletManager._internal();

  factory AbWalletManager() {
    return instance;
  }

  @override
  Future<ABWalletInfo> createWalletByPrivateKeyAndCoinType({
    required String walletName,
    required String password,
    required privateKey,
    required ABChainInfo chainInfo,
  }) async {
    WalletAccountModel walletModel = await WalletMethod.instance.createAccountByPrivateKeyAndType(
      privateKeyHex: privateKey,
      coinType: chainInfo.walletCoreCoinType,
    );
    ABWalletInfo walletInfo = await handleWalletModels(
      walletModels: [walletModel],
      walletType: ABWalletType.privateKey,
      chainInfos: [chainInfo],
      walletName: walletName,
      password: password,
      secretKey: privateKey,
    );
    return walletInfo;
  }

  List<ABProtocolAccount>? _getProtocolAccounts({required WalletAccountModel walletModel}) {
    List<ABProtocolAccount>? protocolAccounts;

    /// todo: for support btc protocol account
    return protocolAccounts;
  }

  Future<ABWalletInfo> handleWalletModels({
    required List<WalletAccountModel> walletModels,
    required String walletName,
    required String password,
    required ABWalletType walletType,
    required List<ABChainInfo> chainInfos,
    required String secretKey,
  }) async {
    var walletId = await ABWalletStorage.instance.getWalletNextId();
    var accountId = await ABWalletStorage.instance.getAccountNextId(walletId: walletId);
    Map<ChainId, ABAccountDetail> accountDetailsMap = {};
    for (int index = 0; index < walletModels.length; index++) {
      var walletModel = walletModels[index];
      ABChainInfo chainInfo = chainInfos[index];
      ABAccountDetail accountDetail = ABAccountDetail(
        defaultAddress: walletModel.accountAddress,
        defaultPublicKey: walletModel.accountPublicKey,
        derivationPath: walletModel.extendedPath,
        chainInfo: chainInfo,
        encryptedKey: WalletMethodUtils.encryptAES(walletModel.accountPrivateKey, password),
        protocolAccounts: _getProtocolAccounts(walletModel: walletModel),
      );
      // 构造 account detail map
      accountDetailsMap[chainInfo.chainId] = accountDetail;
    }
    ABAccount account = ABAccount(
      index: accountId,
      accountName: "Account $accountId",
      accountDetailsMap: accountDetailsMap,
    );
    ABWalletInfo walletInfo = ABWalletInfo(
      walletId: walletId,
      walletIndex: walletId,
      walletName: walletName,
      walletType: walletType,
      walletAccounts: [account],
      encryptStr: WalletMethodUtils.encryptAES(secretKey, password),
    );
    // save to local
    var currentWalletList = await ABWalletStorage.instance.getAllWalletList();
    currentWalletList.add(walletInfo);
    ABWalletStorage.instance.saveWalletList(walletInfo: currentWalletList);
    return walletInfo;
  }

  @override
  Future<ABWalletInfo> createWalletsByMnemonicAndCoinTypes({
    required String walletName,
    required String password,
    required String mnemonic,
    required List<ABChainInfo> chainInfos,
  }) async {
    List<int> coinTypes = chainInfos.map((chain) => chain.walletCoreCoinType).toList();
    List<WalletAccountModel> walletModels = await WalletMethod.instance.createAccountsByMnemonicAndTypes(
      mnemonic: mnemonic,
      coinTypes: coinTypes,
    );
    var walletInfos = await handleWalletModels(
      chainInfos: chainInfos,
      walletModels: walletModels,
      walletName: walletName,
      password: password,
      walletType: ABWalletType.mnemonic,
      secretKey: mnemonic,
    );
    return walletInfos;
  }

  @override
  Future<bool> deleteWallet({required ABWalletInfo walletInfo}) {
    // TODO: implement deleteWallet
    throw UnimplementedError();
  }

  @override
  Future<String?> exportWallet({required ABWalletInfo walletInfo, required String password}) {
    // TODO: implement exportWallet
    throw UnimplementedError();
  }

  @override
  Future<List<ABWalletInfo>> getAllWalletInfos() {
    var res = ABWalletStorage.instance.getAllWalletList();
    return Future.value(res);
  }

  @override
  Future<ABWalletInfo> getDAppSelectedWalletInfo() {
    // TODO: implement getDAppSelectedWalletInfo
    throw UnimplementedError();
  }

  @override
  Future<ABWalletInfo?> getSelectedWalletInfo() {
    // TODO: implement getSelectedWalletInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> modifyWalletName({required ABWalletInfo walletInfo, required String newName}) {
    // TODO: implement modifyWalletName
    throw UnimplementedError();
  }

  @override
  Future<bool> modifyWalletPassword({
    required ABWalletInfo walletInfo,
    required String oldPassword,
    required String newPassword,
  }) {
    // TODO: implement modifyWalletPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> setDAppSelectedWalletInfo({required ABWalletInfo info}) {
    // TODO: implement setDAppSelectedWalletInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> setSelectedWalletInfo({required ABWalletInfo info}) {
    // TODO: implement setSelectedWalletInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> verifyWalletPassword({required ABWalletInfo walletInfo, required String password}) {
    // TODO: implement verifyWalletPassword
    throw UnimplementedError();
  }
}
