enum ABTokenType {
  /// 主代币
  mainToken('mainToken', 0),

  /// evm 系列
  erc20('erc20', 1),
  erc721('erc721', 2),
  erc1155('erc1155', 3),

  /// btc 系列
  brc20('brc20', 4),
  btcnft('btcnft', 5);

  final String protocolName;
  final int protocolIndex;
  const ABTokenType(this.protocolName, this.protocolIndex);

  static ABTokenType fromIndex(int index) {
    switch (index) {
      case 0:
        return ABTokenType.mainToken;
      case 1:
        return ABTokenType.erc20;
      case 2:
        return ABTokenType.erc721;
      case 3:
        return ABTokenType.erc1155;
      case 4:
        return ABTokenType.brc20;
      case 5:
        return ABTokenType.btcnft;
      default:
        throw 'Unknown blockchain index: $index';
    }
  }
}
