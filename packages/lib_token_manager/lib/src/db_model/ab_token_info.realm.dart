// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ab_token_info.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ABTokenInfo extends _ABTokenInfo
    with RealmEntity, RealmObjectBase, RealmObject {
  ABTokenInfo(
    String tokenSymbol,
    String tokenName,
    int tokenDecimals,
    String tokenLogo,
    String tokenType, {
    ABContractInfo? contractInfo,
    ABOridinalsInfo? ordinalsInfo,
  }) {
    RealmObjectBase.set(this, 'tokenSymbol', tokenSymbol);
    RealmObjectBase.set(this, 'tokenName', tokenName);
    RealmObjectBase.set(this, 'tokenDecimals', tokenDecimals);
    RealmObjectBase.set(this, 'tokenLogo', tokenLogo);
    RealmObjectBase.set(this, 'tokenType', tokenType);
    RealmObjectBase.set(this, 'contractInfo', contractInfo);
    RealmObjectBase.set(this, 'ordinalsInfo', ordinalsInfo);
  }

  ABTokenInfo._();

  @override
  String get tokenSymbol =>
      RealmObjectBase.get<String>(this, 'tokenSymbol') as String;
  @override
  set tokenSymbol(String value) =>
      RealmObjectBase.set(this, 'tokenSymbol', value);

  @override
  String get tokenName =>
      RealmObjectBase.get<String>(this, 'tokenName') as String;
  @override
  set tokenName(String value) => RealmObjectBase.set(this, 'tokenName', value);

  @override
  int get tokenDecimals =>
      RealmObjectBase.get<int>(this, 'tokenDecimals') as int;
  @override
  set tokenDecimals(int value) =>
      RealmObjectBase.set(this, 'tokenDecimals', value);

  @override
  String get tokenLogo =>
      RealmObjectBase.get<String>(this, 'tokenLogo') as String;
  @override
  set tokenLogo(String value) => RealmObjectBase.set(this, 'tokenLogo', value);

  @override
  String get tokenType =>
      RealmObjectBase.get<String>(this, 'tokenType') as String;
  @override
  set tokenType(String value) => RealmObjectBase.set(this, 'tokenType', value);

  @override
  ABContractInfo? get contractInfo =>
      RealmObjectBase.get<ABContractInfo>(this, 'contractInfo')
          as ABContractInfo?;
  @override
  set contractInfo(covariant ABContractInfo? value) =>
      RealmObjectBase.set(this, 'contractInfo', value);

  @override
  ABOridinalsInfo? get ordinalsInfo =>
      RealmObjectBase.get<ABOridinalsInfo>(this, 'ordinalsInfo')
          as ABOridinalsInfo?;
  @override
  set ordinalsInfo(covariant ABOridinalsInfo? value) =>
      RealmObjectBase.set(this, 'ordinalsInfo', value);

  @override
  Stream<RealmObjectChanges<ABTokenInfo>> get changes =>
      RealmObjectBase.getChanges<ABTokenInfo>(this);

  @override
  Stream<RealmObjectChanges<ABTokenInfo>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABTokenInfo>(this, keyPaths);

  @override
  ABTokenInfo freeze() => RealmObjectBase.freezeObject<ABTokenInfo>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'tokenSymbol': tokenSymbol.toEJson(),
      'tokenName': tokenName.toEJson(),
      'tokenDecimals': tokenDecimals.toEJson(),
      'tokenLogo': tokenLogo.toEJson(),
      'tokenType': tokenType.toEJson(),
      'contractInfo': contractInfo.toEJson(),
      'ordinalsInfo': ordinalsInfo.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABTokenInfo value) => value.toEJson();
  static ABTokenInfo _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'tokenSymbol': EJsonValue tokenSymbol,
        'tokenName': EJsonValue tokenName,
        'tokenDecimals': EJsonValue tokenDecimals,
        'tokenLogo': EJsonValue tokenLogo,
        'tokenType': EJsonValue tokenType,
      } =>
        ABTokenInfo(
          fromEJson(tokenSymbol),
          fromEJson(tokenName),
          fromEJson(tokenDecimals),
          fromEJson(tokenLogo),
          fromEJson(tokenType),
          contractInfo: fromEJson(ejson['contractInfo']),
          ordinalsInfo: fromEJson(ejson['ordinalsInfo']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABTokenInfo._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABTokenInfo, 'ABTokenInfo', [
      SchemaProperty('tokenSymbol', RealmPropertyType.string),
      SchemaProperty('tokenName', RealmPropertyType.string),
      SchemaProperty('tokenDecimals', RealmPropertyType.int),
      SchemaProperty('tokenLogo', RealmPropertyType.string),
      SchemaProperty('tokenType', RealmPropertyType.string),
      SchemaProperty('contractInfo', RealmPropertyType.object,
          optional: true, linkTarget: 'ABContractInfo'),
      SchemaProperty('ordinalsInfo', RealmPropertyType.object,
          optional: true, linkTarget: 'ABOridinalsInfo'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABContractInfo extends _ABContractInfo
    with RealmEntity, RealmObjectBase, RealmObject {
  ABContractInfo(
    String contractAddress,
  ) {
    RealmObjectBase.set(this, 'contractAddress', contractAddress);
  }

  ABContractInfo._();

  @override
  String get contractAddress =>
      RealmObjectBase.get<String>(this, 'contractAddress') as String;
  @override
  set contractAddress(String value) =>
      RealmObjectBase.set(this, 'contractAddress', value);

  @override
  Stream<RealmObjectChanges<ABContractInfo>> get changes =>
      RealmObjectBase.getChanges<ABContractInfo>(this);

  @override
  Stream<RealmObjectChanges<ABContractInfo>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABContractInfo>(this, keyPaths);

  @override
  ABContractInfo freeze() => RealmObjectBase.freezeObject<ABContractInfo>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'contractAddress': contractAddress.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABContractInfo value) => value.toEJson();
  static ABContractInfo _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'contractAddress': EJsonValue contractAddress,
      } =>
        ABContractInfo(
          fromEJson(contractAddress),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABContractInfo._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABContractInfo, 'ABContractInfo', [
      SchemaProperty('contractAddress', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABOridinalsInfo extends _ABOridinalsInfo
    with RealmEntity, RealmObjectBase, RealmObject {
  ABOridinalsInfo(
    String tick,
  ) {
    RealmObjectBase.set(this, 'tick', tick);
  }

  ABOridinalsInfo._();

  @override
  String get tick => RealmObjectBase.get<String>(this, 'tick') as String;
  @override
  set tick(String value) => RealmObjectBase.set(this, 'tick', value);

  @override
  Stream<RealmObjectChanges<ABOridinalsInfo>> get changes =>
      RealmObjectBase.getChanges<ABOridinalsInfo>(this);

  @override
  Stream<RealmObjectChanges<ABOridinalsInfo>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABOridinalsInfo>(this, keyPaths);

  @override
  ABOridinalsInfo freeze() =>
      RealmObjectBase.freezeObject<ABOridinalsInfo>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'tick': tick.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABOridinalsInfo value) => value.toEJson();
  static ABOridinalsInfo _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'tick': EJsonValue tick,
      } =>
        ABOridinalsInfo(
          fromEJson(tick),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABOridinalsInfo._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABOridinalsInfo, 'ABOridinalsInfo', [
      SchemaProperty('tick', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
