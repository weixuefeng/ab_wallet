import 'dart:convert';

import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_wallet_manager/db_model/ab_wallet_info_db_model.dart';
import 'package:lib_wallet_manager/interface/ab_wallet_storage_interface.dart';
import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_account_detail.dart';
import 'package:lib_wallet_manager/model/ab_protocol_account.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';
import 'package:lib_wallet_manager/model/ab_wallet_type.dart';
import 'package:realm/realm.dart';

class ABWalletRealmStorage extends ABWalletStorageInterface {
  late LocalConfiguration walletDBInfoConfig;
  ABWalletRealmStorage._internal() {
    walletDBInfoConfig = Configuration.local([
      ABWalletDBInfo.schema,
      ABAccountDBModel.schema,
      ABAccountDetailDBModel.schema,
      ABProtocolAccountDBModel.schema,
    ], schemaVersion: 0);
  }

  static final ABWalletRealmStorage instance = ABWalletRealmStorage._internal();

  factory ABWalletRealmStorage() {
    return instance;
  }

  @override
  Future<ABWalletInfo> getWalletByWalletId({required int walletId}) {
    // TODO: implement getWalletByWalletId
    throw UnimplementedError();
  }

  @override
  Future<void> addWalletInfo({required ABWalletInfo walletInfo}) {
    var realm = Realm(walletDBInfoConfig);
    realm.write(() {
      List<ABAccount> accounts = walletInfo.walletAccounts;
      List<ABAccountDBModel> dbAccounts = [];
      accounts.forEach((account) {
        List<ABAccountDetailDBModel> details = [];
        account.accountDetailsMap.values.forEach((detail) {
          List<ABProtocolAccountDBModel> protocolAccounts = [];
          if (detail.protocolAccounts != null && detail.protocolAccounts!.isNotEmpty) {
            detail.protocolAccounts!.forEach((protocol) {
              ABProtocolAccountDBModel protocolModel = ABProtocolAccountDBModel(
                protocol.publicKeyHex,
                protocol.address,
                protocol.derivationPath,
                protocol.protocolType.protocolIndex,
              );
              protocolAccounts.add(protocolModel);
            });
          }
          ABAccountDetailDBModel detailModel = ABAccountDetailDBModel(
            account.id,
            jsonEncode(detail.chainInfo.toJson()),
            detail.defaultPublicKey,
            detail.defaultAddress,
            detail.derivationPath,
            detail.extendedPublicKey,
          );
          details.add(detailModel);
        });
        ABAccountDBModel model = ABAccountDBModel(
          account.id,
          account.walletId,
          account.index,
          account.accountName,
          accountDetails: details,
        );
        dbAccounts.add(model);
      });
      var dbInfo = ABWalletDBInfo(
        walletInfo.id,
        walletInfo.walletId,
        walletInfo.walletIndex,
        walletInfo.walletName,
        walletInfo.walletType.typeIndex,
        walletInfo.encryptStr,
        walletInfo.flag,
        walletAccounts: dbAccounts,
      );
      realm.add(dbInfo);
    });
    return Future.value();
  }

  @override
  Future<List<ABWalletInfo>> getAllWalletList() {
    var realm = Realm(walletDBInfoConfig);
    List<ABWalletInfo> abWalletInfos = [];
    var walletDBInfos = realm.all<ABWalletDBInfo>();
    for (var wallet in walletDBInfos) {
      List<ABAccount> accounts = [];
      var accountsModelList = wallet.walletAccounts;
      if (accountsModelList.isNotEmpty) {
        for (var dbAccount in accountsModelList) {
          Map<int, ABAccountDetail> accountDetailsMap = {};
          List<ABAccountDetailDBModel> accountDBDetails = dbAccount.accountDetails;
          if (accountDBDetails.isNotEmpty) {
            for (var dbAccountDetail in accountDBDetails) {
              ABChainInfo chainInfo = ABChainInfo.fromJson(jsonDecode(dbAccountDetail.chainInfo));
              ABAccountDetail accountDetail = ABAccountDetail(
                chainInfo: chainInfo,
                defaultAddress: dbAccountDetail.defaultAddress,
                defaultPublicKey: dbAccountDetail.defaultPublicKey,
                derivationPath: dbAccountDetail.derivationPath,
                extendedPublicKey: dbAccountDetail.extendedPublicKey,
              );
              accountDetailsMap[chainInfo.chainId] = accountDetail;
            }
          }
          ABAccount tempAccount = ABAccount(
            id: dbAccount.id,
            walletId: dbAccount.walletId,
            index: dbAccount.index,
            accountName: dbAccount.accountName,
            accountDetailsMap: accountDetailsMap,
          );
          accounts.add(tempAccount);
        }
      }
      var abWallet = ABWalletInfo(
        encryptStr: wallet.encryptStr,
        flag: wallet.flag,
        id: wallet.id,
        walletId: wallet.walletId,
        walletName: wallet.walletName,
        walletIndex: wallet.walletIndex,
        walletType: ABWalletType.fromIndex(wallet.walletType),
        walletAccounts: accounts,
      );
      abWalletInfos.add(abWallet);
    }
    realm.close();
    return Future.value(abWalletInfos);
  }

  @override
  Future<bool> updateWalletIndex({required int walletId, required int newIndex}) {
    // TODO: implement updateWalletIndex
    throw UnimplementedError();
  }

  @override
  Future<bool> updateWalletName({required int walletId, required String newName}) {
    // TODO: implement updateWalletName
    throw UnimplementedError();
  }

  @override
  Future<bool> updateWalletPassword({required int walletId, required String oldPassword, required String newPassword}) {
    // TODO: implement updateWalletPassword
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteWalletInfo({required ABWalletInfo walletInfo}) async {
    var realm = Realm(walletDBInfoConfig);
    bool res = false;
    realm.write(() {
      var walletDBInfo = realm.query<ABWalletDBInfo>("flag == '${walletInfo.flag}'");
      if (walletDBInfo.isNotEmpty) {
        realm.delete(walletDBInfo.first);
        res = true;
      } else {
        res = false;
      }
    });
    realm.close();
    return res;
  }

  @override
  Future<bool> addAcountForWallet({required ABWalletInfo walletInfo, required ABAccount accountInfo}) async {
    var realm = Realm(walletDBInfoConfig);
    List<ABAccountDetailDBModel> details = [];

    var walletDBInfo = realm.query<ABWalletDBInfo>("flag == '${walletInfo.flag}'").first;
    if (walletDBInfo.isValid) {
      realm.write(() {
        for (var accountDetail in accountInfo.accountDetailsMap.values) {
          List<ABProtocolAccountDBModel> models = [];
          List<ABProtocolAccount>? protocolAccounts = accountDetail.protocolAccounts;
          if (protocolAccounts != null && protocolAccounts.isNotEmpty) {
            for (var account in protocolAccounts) {
              ABProtocolAccountDBModel model = ABProtocolAccountDBModel(
                account.publicKeyHex,
                account.address,
                account.derivationPath,
                account.protocolType.protocolIndex,
              );
              models.add(model);
            }
          }
          ABAccountDetailDBModel model = ABAccountDetailDBModel(
            accountInfo.index,
            jsonEncode(accountDetail.chainInfo.toJson()),
            accountDetail.defaultPublicKey,
            accountDetail.defaultAddress,
            accountDetail.derivationPath,
            accountDetail.extendedPublicKey,
            protocolAccounts: models,
          );
          details.add(model);
        }
        ABAccountDBModel dbModel = ABAccountDBModel(
          accountInfo.id,
          accountInfo.walletId,
          accountInfo.index,
          accountInfo.accountName,
          accountDetails: details,
        );
        walletDBInfo.walletAccounts.add(dbModel);
      });
      realm.close();
      return true;
    } else {
      realm.close();
      return false;
    }
  }
}
