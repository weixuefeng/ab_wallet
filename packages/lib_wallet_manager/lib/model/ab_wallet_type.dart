enum ABWalletType {
  mnemonic('mnemonic', 0),
  privateKey('privateKey', 1),
  keystore('keystore', 2),
  hardware('hardware', 3),
  mpc('mpc', 4);

  final String walletType;
  final int typeIndex;

  const ABWalletType(this.walletType, this.typeIndex);

  static ABWalletType fromIndex(int index) {
    switch (index) {
      case 0:
        return ABWalletType.mnemonic;
      case 1:
        return ABWalletType.privateKey;
      case 2:
        return ABWalletType.keystore;
      case 3:
        return ABWalletType.hardware;
      case 4:
        return ABWalletType.mpc;
      default:
        throw 'Unknown wallet type index: $index';
    }
  }
}
