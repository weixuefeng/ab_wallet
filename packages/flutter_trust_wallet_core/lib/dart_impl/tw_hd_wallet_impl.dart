part of trust_wallet_core_ffi;

class TWHDWalletImpl extends TWHDWallet {
  static Pointer<Void> create({int strength = 128, String passphrase = ""}) {
    assert(strength >= 128 && strength <= 256 && strength % 32 == 0);
    final _passphraseTWString = TWStringImpl.toTWString(passphrase);
    final wallet = TWHDWallet.TWHDWalletCreate(strength, _passphraseTWString);
    TWStringImpl.delete(_passphraseTWString);
    return wallet;
  }

  static Pointer<Void> createWithMnemonic(String mnemonic, {String passphrase = ""}) {
    if (!TWMnemonicImpl.isValid(mnemonic)) throw Exception(["mnemonic is invalid"]);
    final _passphraseTWString = TWStringImpl.toTWString(passphrase);
    final _mnemonicTWString = TWStringImpl.toTWString(mnemonic);
    final wallet = TWHDWallet.TWHDWalletCreateWithMnemonic(_mnemonicTWString, _passphraseTWString);
    TWStringImpl.delete(_passphraseTWString);
    TWStringImpl.delete(_mnemonicTWString);
    return wallet;
  }

  static Pointer<Void> createWithEntropy(Uint8List bytes, {String passphrase = ""}) {
    final _data = TWData.TWDataCreateWithBytes(bytes.toPointerUint8(), bytes.length);
    final _passphraseTWString = TWStringImpl.toTWString(passphrase);
    final wallet = TWHDWallet.TWHDWalletCreateWithEntropy(_data, _passphraseTWString);
    TWStringImpl.delete(_passphraseTWString);
    TWData.TWDataDelete(_data);
    return wallet;
  }

  static String getAddressForCoin(Pointer<Void> wallet, int coinType) {
    final _address = TWHDWallet.TWHDWalletGetAddressForCoin(wallet, coinType);

    return TWStringImpl.toDartString(_address);
  }

  static Pointer<Void> getDerivedKey(Pointer<Void> wallet, int coin, int account, int change, int address) {
    final _privateKey = TWHDWallet.TWHDWalletGetDerivedKey(wallet, coin, account, change, address);

    return _privateKey;
  }

  static Pointer<Void> getMasterKey(Pointer<Void> wallet, int curve) {
    final _privateKey = TWHDWallet.TWHDWalletGetMasterKey(wallet, curve);

    return _privateKey;
  }

  static void delete(Pointer<Void> wallet) {
    TWHDWallet.TWHDWalletDelete(wallet);
  }

  static Pointer<Void> getKeyForCoin(Pointer<Void> wallet, int coin) {
    final Pointer<Void> privateKey = TWHDWallet.TWHDWalletGetKeyForCoin(wallet, coin);
    return privateKey;
  }

  static Pointer<Void> getKey(Pointer<Void> wallet, int coin, String derivationPath) {
    final _derivationPath = TWStringImpl.toTWString(derivationPath);

    final Pointer<Void> privateKey = TWHDWallet.TWHDWalletGetKey(wallet, coin, _derivationPath);
    TWStringImpl.delete(_derivationPath);
    return privateKey;
  }

  static Uint8List seed(Pointer<Void> wallet) {
    final _data = TWHDWallet.TWHDWalletSeed(wallet);
    return TWData.TWDataBytes(_data).asTypedList(TWData.TWDataSize(_data));
  }

  static String mnemonic(Pointer<Void> wallet) {
    return TWStringImpl.toDartString(TWHDWallet.TWHDWalletMnemonic(wallet));
  }

  static String getExtendedPublicKey(Pointer<Void> wallet, int purpose, int coinType, int twHdVersion) {
    final publicKey = TWHDWallet.TWHDWalletGetExtendedPublicKey(wallet, purpose, coinType, twHdVersion);

    return TWStringImpl.toDartString(publicKey);
  }

  static String getExtendedPrivateKey(Pointer<Void> wallet, int purpose, int coinType, int twHdVersion) {
    final privateKey = TWHDWallet.TWHDWalletGetExtendedPrivateKey(wallet, purpose, coinType, twHdVersion);
    return TWStringImpl.toDartString(privateKey);
  }

  static Pointer<Void> getPrivateKeyFromExtended(String extended, int coin, String derivationPath) {
    final _extended = TWStringImpl.toTWString(extended);
    final _derivationPath = TWStringImpl.toTWString(derivationPath);
    final Pointer<Void> privateKey = TWHDWallet.TWHDWalletGetPrivateKeyFromExtended(_extended, coin, _derivationPath);
    TWStringImpl.delete(_derivationPath);
    return privateKey;
  }

  static Pointer<Void> getPrivateKeyByChainCode(String chainCode, String key, int coin, String derivationPath) {
    final _chainCode = TWStringImpl.toTWString(chainCode);
    final _key = TWStringImpl.toTWString(key);
    final _derivationPath = TWStringImpl.toTWString(derivationPath);
    final Pointer<Void> privateKey = TWHDWallet.TWHDWalletGetPrivateKeyByChainCode(
      _chainCode,
      _key,
      coin,
      _derivationPath,
    );
    TWStringImpl.delete(_derivationPath);
    return privateKey;
  }

  static String getHDNode(String mnemonic, int coin, String derivationPath) {
    final _mnemonic = TWStringImpl.toTWString(mnemonic);
    final _derivationPath = TWStringImpl.toTWString(derivationPath);
    return TWStringImpl.toDartString(TWHDWallet.TWHDWalletGetHDNode(_mnemonic, coin, _derivationPath));
  }

  static Pointer<Void> getPrivateKeyByChainCodeCardano(
    String key,
    String ext,
    String chainCode,
    int coin,
    String derivationPath,
  ) {
    final _chainCode = TWStringImpl.toTWString(chainCode);
    final _key = TWStringImpl.toTWString(key);
    final _ext = TWStringImpl.toTWString(ext);
    final _derivationPath = TWStringImpl.toTWString(derivationPath);
    final Pointer<Void> privateKey = TWHDWallet.TWHDWalletGetPrivateKeyByChainCodeCardano(
      _key,
      _ext,
      _chainCode,
      coin,
      _derivationPath,
    );
    TWStringImpl.delete(_derivationPath);
    return privateKey;
  }

  static String getHDNodeCardano(String mnemonic, int coin, String derivationPath) {
    final _mnemonic = TWStringImpl.toTWString(mnemonic);
    final _derivationPath = TWStringImpl.toTWString(derivationPath);
    return TWStringImpl.toDartString(TWHDWallet.TWHDWalletGetHDNodeCardano(_mnemonic, coin, _derivationPath));
  }
}
