enum ABChainType {
  bitcoin('Bitcoin', 0),

  ehtereum('Ehtereum', 1),

  polkadot('Polkadot', 2),

  cosmos('Cosmos', 3),

  solana('Solana', 4),

  tron('Tron', 5),

  newchain('NewChain', 6);

  final String blockchainName;

  final int blockchainIndex;

  const ABChainType(this.blockchainName, this.blockchainIndex);

  static ABChainType fromIndex(int index) {
    switch (index) {
      case 0:
        return ABChainType.bitcoin;
      case 1:
        return ABChainType.ehtereum;
      case 2:
        return ABChainType.polkadot;
      case 3:
        return ABChainType.cosmos;
      case 4:
        return ABChainType.solana;
      case 5:
        return ABChainType.tron;
      case 6:
        return ABChainType.newchain;
      default:
        throw 'Unknown blockchain index: $index';
    }
  }
}
