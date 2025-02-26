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

  /// ABChainEndpoints constructs;
  ABChainEndpoints({
    this.rpcAddresses,
    this.restfulAddresses,
    this.graphqlAddresses,
    this.grpcAddresses,
    this.wssAddresses,
  });

  @override
  String toString() {
    return 'ABChainEndpoints{rpcAddresses: $rpcAddresses, restfulAddresses: $restfulAddresses, graphqlAddresses: $graphqlAddresses, grpcAddresses: $grpcAddresses, wssAddresses: $wssAddresses}';
  }
}
