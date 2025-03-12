// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ab_wallet_info_db_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ABWalletDBInfo extends _ABWalletDBInfo
    with RealmEntity, RealmObjectBase, RealmObject {
  ABWalletDBInfo(
    int id,
    String walletId,
    int walletIndex,
    String walletName,
    int walletType,
    String encryptStr,
    String flag, {
    Iterable<ABAccountDBModel> walletAccounts = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'walletId', walletId);
    RealmObjectBase.set(this, 'walletIndex', walletIndex);
    RealmObjectBase.set(this, 'walletName', walletName);
    RealmObjectBase.set(this, 'walletType', walletType);
    RealmObjectBase.set<RealmList<ABAccountDBModel>>(
        this, 'walletAccounts', RealmList<ABAccountDBModel>(walletAccounts));
    RealmObjectBase.set(this, 'encryptStr', encryptStr);
    RealmObjectBase.set(this, 'flag', flag);
  }

  ABWalletDBInfo._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get walletId =>
      RealmObjectBase.get<String>(this, 'walletId') as String;
  @override
  set walletId(String value) => RealmObjectBase.set(this, 'walletId', value);

  @override
  int get walletIndex => RealmObjectBase.get<int>(this, 'walletIndex') as int;
  @override
  set walletIndex(int value) => RealmObjectBase.set(this, 'walletIndex', value);

  @override
  String get walletName =>
      RealmObjectBase.get<String>(this, 'walletName') as String;
  @override
  set walletName(String value) =>
      RealmObjectBase.set(this, 'walletName', value);

  @override
  int get walletType => RealmObjectBase.get<int>(this, 'walletType') as int;
  @override
  set walletType(int value) => RealmObjectBase.set(this, 'walletType', value);

  @override
  RealmList<ABAccountDBModel> get walletAccounts =>
      RealmObjectBase.get<ABAccountDBModel>(this, 'walletAccounts')
          as RealmList<ABAccountDBModel>;
  @override
  set walletAccounts(covariant RealmList<ABAccountDBModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get encryptStr =>
      RealmObjectBase.get<String>(this, 'encryptStr') as String;
  @override
  set encryptStr(String value) =>
      RealmObjectBase.set(this, 'encryptStr', value);

  @override
  String get flag => RealmObjectBase.get<String>(this, 'flag') as String;
  @override
  set flag(String value) => RealmObjectBase.set(this, 'flag', value);

  @override
  Stream<RealmObjectChanges<ABWalletDBInfo>> get changes =>
      RealmObjectBase.getChanges<ABWalletDBInfo>(this);

  @override
  Stream<RealmObjectChanges<ABWalletDBInfo>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABWalletDBInfo>(this, keyPaths);

  @override
  ABWalletDBInfo freeze() => RealmObjectBase.freezeObject<ABWalletDBInfo>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'walletId': walletId.toEJson(),
      'walletIndex': walletIndex.toEJson(),
      'walletName': walletName.toEJson(),
      'walletType': walletType.toEJson(),
      'walletAccounts': walletAccounts.toEJson(),
      'encryptStr': encryptStr.toEJson(),
      'flag': flag.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABWalletDBInfo value) => value.toEJson();
  static ABWalletDBInfo _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'walletId': EJsonValue walletId,
        'walletIndex': EJsonValue walletIndex,
        'walletName': EJsonValue walletName,
        'walletType': EJsonValue walletType,
        'encryptStr': EJsonValue encryptStr,
        'flag': EJsonValue flag,
      } =>
        ABWalletDBInfo(
          fromEJson(id),
          fromEJson(walletId),
          fromEJson(walletIndex),
          fromEJson(walletName),
          fromEJson(walletType),
          fromEJson(encryptStr),
          fromEJson(flag),
          walletAccounts: fromEJson(ejson['walletAccounts']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABWalletDBInfo._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABWalletDBInfo, 'ABWalletDBInfo', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('walletId', RealmPropertyType.string),
      SchemaProperty('walletIndex', RealmPropertyType.int),
      SchemaProperty('walletName', RealmPropertyType.string),
      SchemaProperty('walletType', RealmPropertyType.int),
      SchemaProperty('walletAccounts', RealmPropertyType.object,
          linkTarget: 'ABAccountDBModel',
          collectionType: RealmCollectionType.list),
      SchemaProperty('encryptStr', RealmPropertyType.string),
      SchemaProperty('flag', RealmPropertyType.string,
          indexType: RealmIndexType.regular),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABAccountDBModel extends _ABAccountDBModel
    with RealmEntity, RealmObjectBase, RealmObject {
  ABAccountDBModel(
    int id,
    int walletId,
    int index,
    String accountName, {
    Iterable<ABAccountDetailDBModel> accountDetails = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'walletId', walletId);
    RealmObjectBase.set(this, 'index', index);
    RealmObjectBase.set(this, 'accountName', accountName);
    RealmObjectBase.set<RealmList<ABAccountDetailDBModel>>(this,
        'accountDetails', RealmList<ABAccountDetailDBModel>(accountDetails));
  }

  ABAccountDBModel._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get walletId => RealmObjectBase.get<int>(this, 'walletId') as int;
  @override
  set walletId(int value) => RealmObjectBase.set(this, 'walletId', value);

  @override
  int get index => RealmObjectBase.get<int>(this, 'index') as int;
  @override
  set index(int value) => RealmObjectBase.set(this, 'index', value);

  @override
  String get accountName =>
      RealmObjectBase.get<String>(this, 'accountName') as String;
  @override
  set accountName(String value) =>
      RealmObjectBase.set(this, 'accountName', value);

  @override
  RealmList<ABAccountDetailDBModel> get accountDetails =>
      RealmObjectBase.get<ABAccountDetailDBModel>(this, 'accountDetails')
          as RealmList<ABAccountDetailDBModel>;
  @override
  set accountDetails(covariant RealmList<ABAccountDetailDBModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<ABAccountDBModel>> get changes =>
      RealmObjectBase.getChanges<ABAccountDBModel>(this);

  @override
  Stream<RealmObjectChanges<ABAccountDBModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABAccountDBModel>(this, keyPaths);

  @override
  ABAccountDBModel freeze() =>
      RealmObjectBase.freezeObject<ABAccountDBModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'walletId': walletId.toEJson(),
      'index': index.toEJson(),
      'accountName': accountName.toEJson(),
      'accountDetails': accountDetails.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABAccountDBModel value) => value.toEJson();
  static ABAccountDBModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'walletId': EJsonValue walletId,
        'index': EJsonValue index,
        'accountName': EJsonValue accountName,
      } =>
        ABAccountDBModel(
          fromEJson(id),
          fromEJson(walletId),
          fromEJson(index),
          fromEJson(accountName),
          accountDetails: fromEJson(ejson['accountDetails']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABAccountDBModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABAccountDBModel, 'ABAccountDBModel', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('walletId', RealmPropertyType.int),
      SchemaProperty('index', RealmPropertyType.int),
      SchemaProperty('accountName', RealmPropertyType.string),
      SchemaProperty('accountDetails', RealmPropertyType.object,
          linkTarget: 'ABAccountDetailDBModel',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABAccountDetailDBModel extends _ABAccountDetailDBModel
    with RealmEntity, RealmObjectBase, RealmObject {
  ABAccountDetailDBModel(
    int accountId,
    String chainInfo,
    String defaultPublicKey,
    String defaultAddress,
    String derivationPath,
    String extendedPublicKey, {
    Iterable<ABProtocolAccountDBModel> protocolAccounts = const [],
  }) {
    RealmObjectBase.set(this, 'accountId', accountId);
    RealmObjectBase.set(this, 'chainInfo', chainInfo);
    RealmObjectBase.set(this, 'defaultPublicKey', defaultPublicKey);
    RealmObjectBase.set(this, 'defaultAddress', defaultAddress);
    RealmObjectBase.set(this, 'derivationPath', derivationPath);
    RealmObjectBase.set(this, 'extendedPublicKey', extendedPublicKey);
    RealmObjectBase.set<RealmList<ABProtocolAccountDBModel>>(
        this,
        'protocolAccounts',
        RealmList<ABProtocolAccountDBModel>(protocolAccounts));
  }

  ABAccountDetailDBModel._();

  @override
  int get accountId => RealmObjectBase.get<int>(this, 'accountId') as int;
  @override
  set accountId(int value) => RealmObjectBase.set(this, 'accountId', value);

  @override
  String get chainInfo =>
      RealmObjectBase.get<String>(this, 'chainInfo') as String;
  @override
  set chainInfo(String value) => RealmObjectBase.set(this, 'chainInfo', value);

  @override
  String get defaultPublicKey =>
      RealmObjectBase.get<String>(this, 'defaultPublicKey') as String;
  @override
  set defaultPublicKey(String value) =>
      RealmObjectBase.set(this, 'defaultPublicKey', value);

  @override
  String get defaultAddress =>
      RealmObjectBase.get<String>(this, 'defaultAddress') as String;
  @override
  set defaultAddress(String value) =>
      RealmObjectBase.set(this, 'defaultAddress', value);

  @override
  String get derivationPath =>
      RealmObjectBase.get<String>(this, 'derivationPath') as String;
  @override
  set derivationPath(String value) =>
      RealmObjectBase.set(this, 'derivationPath', value);

  @override
  String get extendedPublicKey =>
      RealmObjectBase.get<String>(this, 'extendedPublicKey') as String;
  @override
  set extendedPublicKey(String value) =>
      RealmObjectBase.set(this, 'extendedPublicKey', value);

  @override
  RealmList<ABProtocolAccountDBModel> get protocolAccounts =>
      RealmObjectBase.get<ABProtocolAccountDBModel>(this, 'protocolAccounts')
          as RealmList<ABProtocolAccountDBModel>;
  @override
  set protocolAccounts(covariant RealmList<ABProtocolAccountDBModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<ABAccountDetailDBModel>> get changes =>
      RealmObjectBase.getChanges<ABAccountDetailDBModel>(this);

  @override
  Stream<RealmObjectChanges<ABAccountDetailDBModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABAccountDetailDBModel>(this, keyPaths);

  @override
  ABAccountDetailDBModel freeze() =>
      RealmObjectBase.freezeObject<ABAccountDetailDBModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'accountId': accountId.toEJson(),
      'chainInfo': chainInfo.toEJson(),
      'defaultPublicKey': defaultPublicKey.toEJson(),
      'defaultAddress': defaultAddress.toEJson(),
      'derivationPath': derivationPath.toEJson(),
      'extendedPublicKey': extendedPublicKey.toEJson(),
      'protocolAccounts': protocolAccounts.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABAccountDetailDBModel value) => value.toEJson();
  static ABAccountDetailDBModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'accountId': EJsonValue accountId,
        'chainInfo': EJsonValue chainInfo,
        'defaultPublicKey': EJsonValue defaultPublicKey,
        'defaultAddress': EJsonValue defaultAddress,
        'derivationPath': EJsonValue derivationPath,
        'extendedPublicKey': EJsonValue extendedPublicKey,
      } =>
        ABAccountDetailDBModel(
          fromEJson(accountId),
          fromEJson(chainInfo),
          fromEJson(defaultPublicKey),
          fromEJson(defaultAddress),
          fromEJson(derivationPath),
          fromEJson(extendedPublicKey),
          protocolAccounts: fromEJson(ejson['protocolAccounts']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABAccountDetailDBModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, ABAccountDetailDBModel,
        'ABAccountDetailDBModel', [
      SchemaProperty('accountId', RealmPropertyType.int),
      SchemaProperty('chainInfo', RealmPropertyType.string),
      SchemaProperty('defaultPublicKey', RealmPropertyType.string),
      SchemaProperty('defaultAddress', RealmPropertyType.string),
      SchemaProperty('derivationPath', RealmPropertyType.string),
      SchemaProperty('extendedPublicKey', RealmPropertyType.string),
      SchemaProperty('protocolAccounts', RealmPropertyType.object,
          linkTarget: 'ABProtocolAccountDBModel',
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABProtocolAccountDBModel extends _ABProtocolAccountDBModel
    with RealmEntity, RealmObjectBase, RealmObject {
  ABProtocolAccountDBModel(
    String publicKeyHex,
    String address,
    String derivationPath,
    int protocolType,
  ) {
    RealmObjectBase.set(this, 'publicKeyHex', publicKeyHex);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'derivationPath', derivationPath);
    RealmObjectBase.set(this, 'protocolType', protocolType);
  }

  ABProtocolAccountDBModel._();

  @override
  String get publicKeyHex =>
      RealmObjectBase.get<String>(this, 'publicKeyHex') as String;
  @override
  set publicKeyHex(String value) =>
      RealmObjectBase.set(this, 'publicKeyHex', value);

  @override
  String get address => RealmObjectBase.get<String>(this, 'address') as String;
  @override
  set address(String value) => RealmObjectBase.set(this, 'address', value);

  @override
  String get derivationPath =>
      RealmObjectBase.get<String>(this, 'derivationPath') as String;
  @override
  set derivationPath(String value) =>
      RealmObjectBase.set(this, 'derivationPath', value);

  @override
  int get protocolType => RealmObjectBase.get<int>(this, 'protocolType') as int;
  @override
  set protocolType(int value) =>
      RealmObjectBase.set(this, 'protocolType', value);

  @override
  Stream<RealmObjectChanges<ABProtocolAccountDBModel>> get changes =>
      RealmObjectBase.getChanges<ABProtocolAccountDBModel>(this);

  @override
  Stream<RealmObjectChanges<ABProtocolAccountDBModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABProtocolAccountDBModel>(this, keyPaths);

  @override
  ABProtocolAccountDBModel freeze() =>
      RealmObjectBase.freezeObject<ABProtocolAccountDBModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'publicKeyHex': publicKeyHex.toEJson(),
      'address': address.toEJson(),
      'derivationPath': derivationPath.toEJson(),
      'protocolType': protocolType.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABProtocolAccountDBModel value) => value.toEJson();
  static ABProtocolAccountDBModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'publicKeyHex': EJsonValue publicKeyHex,
        'address': EJsonValue address,
        'derivationPath': EJsonValue derivationPath,
        'protocolType': EJsonValue protocolType,
      } =>
        ABProtocolAccountDBModel(
          fromEJson(publicKeyHex),
          fromEJson(address),
          fromEJson(derivationPath),
          fromEJson(protocolType),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABProtocolAccountDBModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, ABProtocolAccountDBModel,
        'ABProtocolAccountDBModel', [
      SchemaProperty('publicKeyHex', RealmPropertyType.string),
      SchemaProperty('address', RealmPropertyType.string),
      SchemaProperty('derivationPath', RealmPropertyType.string),
      SchemaProperty('protocolType', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
