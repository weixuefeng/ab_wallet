import 'package:lib_chain_manager/model/ab_chain_info.dart';
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

class ABWalletManager extends ABWalletManagerInterface {
  ABWalletManager._internal();

  static final ABWalletManager instance = ABWalletManager._internal();

  factory ABWalletManager() {
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
    // check exist
    var currentWalletList = await ABWalletStorage.instance.getAllWalletList();
    String flag = "";
    if (walletType == ABWalletType.mnemonic) {
      flag = WalletMethodUtils.walletFlag(secretKey);
    } else if (walletType == ABWalletType.privateKey) {
      if (chainInfos.length > 1) {
        throw Exception("private key wallet only support one chain");
      }
      flag = WalletMethodUtils.walletFlag(secretKey + chainInfos[0].chainId.toString());
    } else {
      throw Exception("not support wallet type $walletType");
    }
    var index = currentWalletList.indexWhere((element) => element.flag == flag);
    if (index > -1) {
      throw Exception("wallet already exist");
    }
    // create new wallet
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
        extendedPublicKey: walletModel.accountExtendedPublicKey,
        // encryptedKey: WalletMethodUtils.encryptAES(walletModel.accountPrivateKey, password),
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
      flag: flag,
      encryptStr: WalletMethodUtils.encryptAES(secretKey, password),
    );
    // save to local
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
    return ABWalletStorage.instance.deleteWalletInfo(walletInfo: walletInfo);
  }

  @override
  Future<ABAccount> addAcountForWallet({required ABWalletInfo info, required String password}) async {
    var accountId = await ABWalletStorage.instance.getAccountNextId(walletId: info.walletId);
    Map<ChainId, ABAccountDetail> accountDetailsMap = {};
    info.walletAccounts[0].accountDetailsMap.values.forEach((detail) async {
      WalletAccountModel walleModel = await WalletMethod.instance.createAccountsByExtenedPublicKey(
        extenedPublicKey: detail.extendedPublicKey,
        coinType: detail.chainInfo.walletCoreCoinType,
        position: accountId,
      );
      accountDetailsMap[detail.chainInfo.chainId] = ABAccountDetail(
        defaultAddress: walleModel.accountAddress,
        defaultPublicKey: walleModel.accountPublicKey,
        derivationPath: walleModel.extendedPath,
        chainInfo: detail.chainInfo,
        extendedPublicKey: walleModel.accountExtendedPublicKey,
        // encryptedKey: WalletMethodUtils.encryptAES(walleModel.accountPrivateKey, password.toString()),
        protocolAccounts: _getProtocolAccounts(walletModel: walleModel),
      );
    });
    ABAccount account = ABAccount(
      index: accountId,
      accountName: "Account $accountId",
      accountDetailsMap: accountDetailsMap,
    );
    info.walletAccounts.add(account);
    await ABWalletStorage.instance.updateWalletInfo(walletInfo: info);
    return account;
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

  @override
  Future<String> decryptWallet({
    required ABWalletInfo walletInfo,
    required String password,
    required ABAccount account,
    required int chainId,
  }) async {
    var secretKey = WalletMethodUtils.decryptAES(walletInfo.encryptStr, password);
    if (walletInfo.walletType == ABWalletType.privateKey) {
      return Future.value(secretKey);
    }
    ABAccountDetail? accountDetail = account.accountDetailsMap[chainId];
    if (accountDetail == null) {
      throw Exception("accountDetail is null");
    }
    int coinType = accountDetail.chainInfo.walletCoreCoinType;
    var privateKey = await WalletMethod.instance.exportPrivateKeyByMnemonicAndType(
      mnemonic: secretKey,
      coinType: coinType,
      index: account.index,
    );
    return Future.value(privateKey);
  }
}
