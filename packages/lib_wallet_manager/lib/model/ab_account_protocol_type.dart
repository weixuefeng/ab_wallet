enum ABAccountProtocolType {
  /// btc
  bip44('Legacy', 0),
  bip49('Nested SegWit', 1),
  bip84('Native SegWit', 2),
  bip86('Taproot', 3),

  /// bitcoin cash,todo
  cashAddress('CashAddress', 4);

  final String protocolName;
  final int protocolIndex;

  static ABAccountProtocolType fromIndex(int index) {
    switch (index) {
      case 0:
        return bip44;
      case 1:
        return bip49;
      case 2:
        return bip84;
      case 3:
        return bip86;
      case 4:
        return cashAddress;
      default:
        throw ArgumentError('invalid protocol index');
    }
  }

  const ABAccountProtocolType(this.protocolName, this.protocolIndex);
}
