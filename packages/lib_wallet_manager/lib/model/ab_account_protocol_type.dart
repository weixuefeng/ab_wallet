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

  const ABAccountProtocolType(this.protocolName, this.protocolIndex);
}
