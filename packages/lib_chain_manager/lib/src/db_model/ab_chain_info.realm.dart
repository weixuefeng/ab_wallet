// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ab_chain_info.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class ABChainInfo extends _ABChainInfo
    with RealmEntity, RealmObjectBase, RealmObject {
  ABChainInfo(
    int chainId,
    int walletCoreCoinType,
    String chainName,
    String chainType,
    String networkType,
    String chainLogo,
    String derivationPath, {
    ABChainEndpoints? endpoints,
    ABTokenInfoAdapter? mainTokenInfo,
    int? evmChainId,
  }) {
    RealmObjectBase.set(this, 'chainId', chainId);
    RealmObjectBase.set(this, 'walletCoreCoinType', walletCoreCoinType);
    RealmObjectBase.set(this, 'chainName', chainName);
    RealmObjectBase.set(this, 'chainType', chainType);
    RealmObjectBase.set(this, 'networkType', networkType);
    RealmObjectBase.set(this, 'chainLogo', chainLogo);
    RealmObjectBase.set(this, 'endpoints', endpoints);
    RealmObjectBase.set(this, 'derivationPath', derivationPath);
    RealmObjectBase.set(this, 'mainTokenInfo', mainTokenInfo);
    RealmObjectBase.set(this, 'evmChainId', evmChainId);
  }

  ABChainInfo._();

  @override
  int get chainId => RealmObjectBase.get<int>(this, 'chainId') as int;
  @override
  set chainId(int value) => RealmObjectBase.set(this, 'chainId', value);

  @override
  int get walletCoreCoinType =>
      RealmObjectBase.get<int>(this, 'walletCoreCoinType') as int;
  @override
  set walletCoreCoinType(int value) =>
      RealmObjectBase.set(this, 'walletCoreCoinType', value);

  @override
  String get chainName =>
      RealmObjectBase.get<String>(this, 'chainName') as String;
  @override
  set chainName(String value) => RealmObjectBase.set(this, 'chainName', value);

  @override
  String get chainType =>
      RealmObjectBase.get<String>(this, 'chainType') as String;
  @override
  set chainType(String value) => RealmObjectBase.set(this, 'chainType', value);

  @override
  String get networkType =>
      RealmObjectBase.get<String>(this, 'networkType') as String;
  @override
  set networkType(String value) =>
      RealmObjectBase.set(this, 'networkType', value);

  @override
  String get chainLogo =>
      RealmObjectBase.get<String>(this, 'chainLogo') as String;
  @override
  set chainLogo(String value) => RealmObjectBase.set(this, 'chainLogo', value);

  @override
  ABChainEndpoints? get endpoints =>
      RealmObjectBase.get<ABChainEndpoints>(this, 'endpoints')
          as ABChainEndpoints?;
  @override
  set endpoints(covariant ABChainEndpoints? value) =>
      RealmObjectBase.set(this, 'endpoints', value);

  @override
  String get derivationPath =>
      RealmObjectBase.get<String>(this, 'derivationPath') as String;
  @override
  set derivationPath(String value) =>
      RealmObjectBase.set(this, 'derivationPath', value);

  @override
  ABTokenInfoAdapter? get mainTokenInfo =>
      RealmObjectBase.get<ABTokenInfoAdapter>(this, 'mainTokenInfo')
          as ABTokenInfoAdapter?;
  @override
  set mainTokenInfo(covariant ABTokenInfoAdapter? value) =>
      RealmObjectBase.set(this, 'mainTokenInfo', value);

  @override
  int? get evmChainId => RealmObjectBase.get<int>(this, 'evmChainId') as int?;
  @override
  set evmChainId(int? value) => RealmObjectBase.set(this, 'evmChainId', value);

  @override
  Stream<RealmObjectChanges<ABChainInfo>> get changes =>
      RealmObjectBase.getChanges<ABChainInfo>(this);

  @override
  Stream<RealmObjectChanges<ABChainInfo>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABChainInfo>(this, keyPaths);

  @override
  ABChainInfo freeze() => RealmObjectBase.freezeObject<ABChainInfo>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'chainId': chainId.toEJson(),
      'walletCoreCoinType': walletCoreCoinType.toEJson(),
      'chainName': chainName.toEJson(),
      'chainType': chainType.toEJson(),
      'networkType': networkType.toEJson(),
      'chainLogo': chainLogo.toEJson(),
      'endpoints': endpoints.toEJson(),
      'derivationPath': derivationPath.toEJson(),
      'mainTokenInfo': mainTokenInfo.toEJson(),
      'evmChainId': evmChainId.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABChainInfo value) => value.toEJson();
  static ABChainInfo _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'chainId': EJsonValue chainId,
        'walletCoreCoinType': EJsonValue walletCoreCoinType,
        'chainName': EJsonValue chainName,
        'chainType': EJsonValue chainType,
        'networkType': EJsonValue networkType,
        'chainLogo': EJsonValue chainLogo,
        'derivationPath': EJsonValue derivationPath,
      } =>
        ABChainInfo(
          fromEJson(chainId),
          fromEJson(walletCoreCoinType),
          fromEJson(chainName),
          fromEJson(chainType),
          fromEJson(networkType),
          fromEJson(chainLogo),
          fromEJson(derivationPath),
          endpoints: fromEJson(ejson['endpoints']),
          mainTokenInfo: fromEJson(ejson['mainTokenInfo']),
          evmChainId: fromEJson(ejson['evmChainId']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABChainInfo._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABChainInfo, 'ABChainInfo', [
      SchemaProperty('chainId', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('walletCoreCoinType', RealmPropertyType.int),
      SchemaProperty('chainName', RealmPropertyType.string),
      SchemaProperty('chainType', RealmPropertyType.string),
      SchemaProperty('networkType', RealmPropertyType.string),
      SchemaProperty('chainLogo', RealmPropertyType.string),
      SchemaProperty('endpoints', RealmPropertyType.object,
          optional: true, linkTarget: 'ABChainEndpoints'),
      SchemaProperty('derivationPath', RealmPropertyType.string),
      SchemaProperty('mainTokenInfo', RealmPropertyType.object,
          optional: true, linkTarget: 'ABTokenInfoAdapter'),
      SchemaProperty('evmChainId', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABChainEndpoints extends _ABChainEndpoints
    with RealmEntity, RealmObjectBase, RealmObject {
  ABChainEndpoints(
    String selectedEndpoints,
    String explorerAddresses, {
    Iterable<String> rpcAddresses = const [],
    Iterable<String> restfulAddresses = const [],
    Iterable<String> graphqlAddresses = const [],
    Iterable<String> grpcAddresses = const [],
    Iterable<String> wssAddresses = const [],
  }) {
    RealmObjectBase.set<RealmList<String>>(
        this, 'rpcAddresses', RealmList<String>(rpcAddresses));
    RealmObjectBase.set<RealmList<String>>(
        this, 'restfulAddresses', RealmList<String>(restfulAddresses));
    RealmObjectBase.set<RealmList<String>>(
        this, 'graphqlAddresses', RealmList<String>(graphqlAddresses));
    RealmObjectBase.set<RealmList<String>>(
        this, 'grpcAddresses', RealmList<String>(grpcAddresses));
    RealmObjectBase.set<RealmList<String>>(
        this, 'wssAddresses', RealmList<String>(wssAddresses));
    RealmObjectBase.set(this, 'selectedEndpoints', selectedEndpoints);
    RealmObjectBase.set(this, 'explorerAddresses', explorerAddresses);
  }

  ABChainEndpoints._();

  @override
  RealmList<String> get rpcAddresses =>
      RealmObjectBase.get<String>(this, 'rpcAddresses') as RealmList<String>;
  @override
  set rpcAddresses(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get restfulAddresses =>
      RealmObjectBase.get<String>(this, 'restfulAddresses')
          as RealmList<String>;
  @override
  set restfulAddresses(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get graphqlAddresses =>
      RealmObjectBase.get<String>(this, 'graphqlAddresses')
          as RealmList<String>;
  @override
  set graphqlAddresses(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get grpcAddresses =>
      RealmObjectBase.get<String>(this, 'grpcAddresses') as RealmList<String>;
  @override
  set grpcAddresses(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get wssAddresses =>
      RealmObjectBase.get<String>(this, 'wssAddresses') as RealmList<String>;
  @override
  set wssAddresses(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get selectedEndpoints =>
      RealmObjectBase.get<String>(this, 'selectedEndpoints') as String;
  @override
  set selectedEndpoints(String value) =>
      RealmObjectBase.set(this, 'selectedEndpoints', value);

  @override
  String get explorerAddresses =>
      RealmObjectBase.get<String>(this, 'explorerAddresses') as String;
  @override
  set explorerAddresses(String value) =>
      RealmObjectBase.set(this, 'explorerAddresses', value);

  @override
  Stream<RealmObjectChanges<ABChainEndpoints>> get changes =>
      RealmObjectBase.getChanges<ABChainEndpoints>(this);

  @override
  Stream<RealmObjectChanges<ABChainEndpoints>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABChainEndpoints>(this, keyPaths);

  @override
  ABChainEndpoints freeze() =>
      RealmObjectBase.freezeObject<ABChainEndpoints>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'rpcAddresses': rpcAddresses.toEJson(),
      'restfulAddresses': restfulAddresses.toEJson(),
      'graphqlAddresses': graphqlAddresses.toEJson(),
      'grpcAddresses': grpcAddresses.toEJson(),
      'wssAddresses': wssAddresses.toEJson(),
      'selectedEndpoints': selectedEndpoints.toEJson(),
      'explorerAddresses': explorerAddresses.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABChainEndpoints value) => value.toEJson();
  static ABChainEndpoints _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'selectedEndpoints': EJsonValue selectedEndpoints,
        'explorerAddresses': EJsonValue explorerAddresses,
      } =>
        ABChainEndpoints(
          fromEJson(selectedEndpoints),
          fromEJson(explorerAddresses),
          rpcAddresses: fromEJson(ejson['rpcAddresses']),
          restfulAddresses: fromEJson(ejson['restfulAddresses']),
          graphqlAddresses: fromEJson(ejson['graphqlAddresses']),
          grpcAddresses: fromEJson(ejson['grpcAddresses']),
          wssAddresses: fromEJson(ejson['wssAddresses']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABChainEndpoints._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABChainEndpoints, 'ABChainEndpoints', [
      SchemaProperty('rpcAddresses', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('restfulAddresses', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('graphqlAddresses', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('grpcAddresses', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('wssAddresses', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('selectedEndpoints', RealmPropertyType.string),
      SchemaProperty('explorerAddresses', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABTokenInfoAdapter extends _ABTokenInfoAdapter
    with RealmEntity, RealmObjectBase, RealmObject {
  ABTokenInfoAdapter(
    String tokenSymbol,
    String tokenName,
    int tokenDecimals,
    String tokenLogo,
    String tokenType, {
    ABContractInfoAdapter? contractInfo,
    ABOridinalsInfoAdapter? ordinalsInfo,
  }) {
    RealmObjectBase.set(this, 'tokenSymbol', tokenSymbol);
    RealmObjectBase.set(this, 'tokenName', tokenName);
    RealmObjectBase.set(this, 'tokenDecimals', tokenDecimals);
    RealmObjectBase.set(this, 'tokenLogo', tokenLogo);
    RealmObjectBase.set(this, 'tokenType', tokenType);
    RealmObjectBase.set(this, 'contractInfo', contractInfo);
    RealmObjectBase.set(this, 'ordinalsInfo', ordinalsInfo);
  }

  ABTokenInfoAdapter._();

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
  ABContractInfoAdapter? get contractInfo =>
      RealmObjectBase.get<ABContractInfoAdapter>(this, 'contractInfo')
          as ABContractInfoAdapter?;
  @override
  set contractInfo(covariant ABContractInfoAdapter? value) =>
      RealmObjectBase.set(this, 'contractInfo', value);

  @override
  ABOridinalsInfoAdapter? get ordinalsInfo =>
      RealmObjectBase.get<ABOridinalsInfoAdapter>(this, 'ordinalsInfo')
          as ABOridinalsInfoAdapter?;
  @override
  set ordinalsInfo(covariant ABOridinalsInfoAdapter? value) =>
      RealmObjectBase.set(this, 'ordinalsInfo', value);

  @override
  Stream<RealmObjectChanges<ABTokenInfoAdapter>> get changes =>
      RealmObjectBase.getChanges<ABTokenInfoAdapter>(this);

  @override
  Stream<RealmObjectChanges<ABTokenInfoAdapter>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABTokenInfoAdapter>(this, keyPaths);

  @override
  ABTokenInfoAdapter freeze() =>
      RealmObjectBase.freezeObject<ABTokenInfoAdapter>(this);

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

  static EJsonValue _toEJson(ABTokenInfoAdapter value) => value.toEJson();
  static ABTokenInfoAdapter _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'tokenSymbol': EJsonValue tokenSymbol,
        'tokenName': EJsonValue tokenName,
        'tokenDecimals': EJsonValue tokenDecimals,
        'tokenLogo': EJsonValue tokenLogo,
        'tokenType': EJsonValue tokenType,
      } =>
        ABTokenInfoAdapter(
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
    RealmObjectBase.registerFactory(ABTokenInfoAdapter._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, ABTokenInfoAdapter, 'ABTokenInfoAdapter', [
      SchemaProperty('tokenSymbol', RealmPropertyType.string),
      SchemaProperty('tokenName', RealmPropertyType.string),
      SchemaProperty('tokenDecimals', RealmPropertyType.int),
      SchemaProperty('tokenLogo', RealmPropertyType.string),
      SchemaProperty('tokenType', RealmPropertyType.string),
      SchemaProperty('contractInfo', RealmPropertyType.object,
          optional: true, linkTarget: 'ABContractInfoAdapter'),
      SchemaProperty('ordinalsInfo', RealmPropertyType.object,
          optional: true, linkTarget: 'ABOridinalsInfoAdapter'),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABContractInfoAdapter extends _ABContractInfoAdapter
    with RealmEntity, RealmObjectBase, RealmObject {
  ABContractInfoAdapter(
    String contractAddress,
  ) {
    RealmObjectBase.set(this, 'contractAddress', contractAddress);
  }

  ABContractInfoAdapter._();

  @override
  String get contractAddress =>
      RealmObjectBase.get<String>(this, 'contractAddress') as String;
  @override
  set contractAddress(String value) =>
      RealmObjectBase.set(this, 'contractAddress', value);

  @override
  Stream<RealmObjectChanges<ABContractInfoAdapter>> get changes =>
      RealmObjectBase.getChanges<ABContractInfoAdapter>(this);

  @override
  Stream<RealmObjectChanges<ABContractInfoAdapter>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABContractInfoAdapter>(this, keyPaths);

  @override
  ABContractInfoAdapter freeze() =>
      RealmObjectBase.freezeObject<ABContractInfoAdapter>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'contractAddress': contractAddress.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABContractInfoAdapter value) => value.toEJson();
  static ABContractInfoAdapter _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'contractAddress': EJsonValue contractAddress,
      } =>
        ABContractInfoAdapter(
          fromEJson(contractAddress),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABContractInfoAdapter._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, ABContractInfoAdapter,
        'ABContractInfoAdapter', [
      SchemaProperty('contractAddress', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ABOridinalsInfoAdapter extends _ABOridinalsInfoAdapter
    with RealmEntity, RealmObjectBase, RealmObject {
  ABOridinalsInfoAdapter(
    String tick,
  ) {
    RealmObjectBase.set(this, 'tick', tick);
  }

  ABOridinalsInfoAdapter._();

  @override
  String get tick => RealmObjectBase.get<String>(this, 'tick') as String;
  @override
  set tick(String value) => RealmObjectBase.set(this, 'tick', value);

  @override
  Stream<RealmObjectChanges<ABOridinalsInfoAdapter>> get changes =>
      RealmObjectBase.getChanges<ABOridinalsInfoAdapter>(this);

  @override
  Stream<RealmObjectChanges<ABOridinalsInfoAdapter>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ABOridinalsInfoAdapter>(this, keyPaths);

  @override
  ABOridinalsInfoAdapter freeze() =>
      RealmObjectBase.freezeObject<ABOridinalsInfoAdapter>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'tick': tick.toEJson(),
    };
  }

  static EJsonValue _toEJson(ABOridinalsInfoAdapter value) => value.toEJson();
  static ABOridinalsInfoAdapter _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'tick': EJsonValue tick,
      } =>
        ABOridinalsInfoAdapter(
          fromEJson(tick),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ABOridinalsInfoAdapter._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, ABOridinalsInfoAdapter,
        'ABOridinalsInfoAdapter', [
      SchemaProperty('tick', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
