class ABChainEndpoints {
  /// chain rpc addresses
  List<String>? rpcAddresses;

  /// chain restful addresses;
  List<String>? restfulAddresses;

  /// chain graphql addresses;
  List<String>? graphqlAddresses;

  /// chain grpc addresses;
  List<String>? grpcAddresses;

  /// chain wss enedpoints
  List<String>? wssAddresses;

  String? selectedEndpoints;

  /// ABChainEndpoints constructs;
  ABChainEndpoints({
    this.rpcAddresses,
    this.restfulAddresses,
    this.graphqlAddresses,
    this.grpcAddresses,
    this.wssAddresses,
    this.selectedEndpoints,
  });

  @override
  String toString() {
    return 'ABChainEndpoints{rpcAddresses: $rpcAddresses, restfulAddresses: $restfulAddresses, graphqlAddresses: $graphqlAddresses, grpcAddresses: $grpcAddresses, wssAddresses: $wssAddresses}';
  }

  toJson() {
    return {
      'rpcAddresses': rpcAddresses,
      'restfulAddresses': restfulAddresses,
      'graphqlAddresses': graphqlAddresses,
      'grpcAddresses': grpcAddresses,
      'wssAddresses': wssAddresses,
      'selectedEndpoints': selectedEndpoints,
    };
  }

  factory ABChainEndpoints.fromJson(Map<String, dynamic> json) {
    return ABChainEndpoints(
      rpcAddresses:
          json['rpcAddresses'] == null ? null : (json['rpcAddresses'] as List).map((e) => e as String).toList(),
      restfulAddresses:
          json['restfulAddresses'] == null
              ? null
              : (json['restfulAddresses'] as List)?.map((e) => e as String).toList(),
      graphqlAddresses:
          json['graphqlAddresses'] == null
              ? null
              : (json['graphqlAddresses'] as List)?.map((e) => e as String).toList(),
      grpcAddresses:
          json['grpcAddresses'] == null ? null : (json['grpcAddresses'] as List)?.map((e) => e as String).toList(),
      wssAddresses:
          json['wssAddresses'] == null ? null : (json['wssAddresses'] as List)?.map((e) => e as String).toList(),
      selectedEndpoints: json['selectedEndpoints'] == null ? null : (json['selectedEndpoints'] as String),
    );
  }
}
