import 'package:realm/realm.dart';
part 'ab_wallet_info_db_model.realm.dart';

@RealmModel()
class _ABWalletDBInfo {
  @PrimaryKey()
  late int id;

  /// wallet id
  late String walletId;

  /// wallet index
  late int walletIndex;

  /// wallet name
  late String walletName;

  /// wallet type
  late int walletType;

  /// wallet accounts
  late List<_ABAccountDBModel> walletAccounts;

  // encrypt string
  late String encryptStr;

  // wallet flag
  @Indexed() // flag 唯一
  late String flag;
}

@RealmModel()
class _ABAccountDBModel {
  @PrimaryKey()
  late int id;

  /// 关联的 walletId
  late int walletId;

  /// account index;
  late int index;

  /// account name;
  late String accountName;

  /// 账户详情
  late List<_ABAccountDetailDBModel> accountDetails;
}

@RealmModel()
class _ABAccountDetailDBModel {
  /// 关联的 accountID
  late int accountId;

  late String chainInfo;

  /// 公钥信息
  late String defaultPublicKey;

  /// 账户地址
  late String defaultAddress;

  /// 衍生路径
  late String derivationPath;

  // 扩展公钥
  late String extendedPublicKey;

  // 协议账户
  late List<_ABProtocolAccountDBModel> protocolAccounts;
}

@RealmModel()
class _ABProtocolAccountDBModel {
  /// 公钥信息
  late String publicKeyHex;

  /// 账户地址
  late String address;

  /// 衍生路径
  late String derivationPath;

  /// 协议类型
  late int protocolType;
}
