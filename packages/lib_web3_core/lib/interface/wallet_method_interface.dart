import 'package:lib_web3_core/model/wallet_account_model.dart';

abstract class WalletMethodInterface {
  /// 生成助记词
  String generateMnemonic({int wordNumber = 12});

  /// 根据助记词，coinType 创建钱包
  Future<WalletAccountModel> createAccountByMnemonicAndType({required String mnemonic, required int coinType});

  /// 根据助记词，coinType 创建多个币种钱包
  Future<List<WalletAccountModel>> createAccountsByMnemonicAndTypes({
    required String mnemonic,
    required List<int> coinTypes,
  });

  /// 根据私钥创建单个钱包
  Future<WalletAccountModel> createAccountByPrivateKeyAndType({required String privateKeyHex, required int coinType});

  /// 根据私钥创建多个钱包账户
  Future<List<WalletAccountModel>> createAccountsByPrivateKeyAndTypes({
    required String privateKeyHex,
    required List<int> coinTypes,
  });

  /// 根据扩展私钥创建钱包账户
  Future<WalletAccountModel> createAccountsByExtenedPrivateKey({
    required String extenedPrivateKey,
    required String derivationPath,
    required int coinType,
    required int position,
    int? deriveIndex,
  });

  /// 根据 keystore 和 coinType 创建钱包
  Future<WalletAccountModel> createAccountByKeystore({
    required String keystore,
    required String password,
    required int coinType,
  });

  /// 导出 keystore
  Future<String> exportKeysotreByPrivateKey({required String privateKeyHex, required String password});
}
