import 'package:lib_chain_manager/model/ab_chain_info.dart';
import 'package:lib_wallet_manager/model/ab_account.dart';
import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

abstract class ABWalletManagerInterface {
  /// 获取所有钱包信息
  Future<List<ABWalletInfo>> getAllWalletInfos();

  /// 给钱包添加账户
  Future<ABAccount> addAcountForWallet({required ABWalletInfo info, required String password});

  /// 设置当前选中的钱包信息
  Future<bool> setSelectedWalletInfo({required ABWalletInfo info});

  /// 获取当前选中的钱包信息
  Future<ABWalletInfo?> getSelectedWalletInfo();

  /// 设置 DApp 当前选中的钱包信息
  Future<bool> setDAppSelectedWalletInfo({required ABWalletInfo info});

  /// 获取DApp当前选中的钱包信息
  Future<ABWalletInfo> getDAppSelectedWalletInfo();

  /// 创建钱包
  Future<ABWalletInfo> createWalletsByMnemonicAndCoinTypes({
    required String walletName,
    required String password,
    required String mnemonic,
    required List<ABChainInfo> chainInfos,
  });

  /// 创建私钥钱包
  Future<ABWalletInfo> createWalletByPrivateKeyAndCoinType({
    required String walletName,
    required String privateKey,
    required String password,
    required ABChainInfo chainInfo,
  });

  /// 删除钱包
  Future<bool> deleteWallet({required ABWalletInfo walletInfo});

  /// 导出 keystore 钱包
  Future<String?> exportWallet({required ABWalletInfo walletInfo, required String password});

  /// 修改钱包名称
  Future<bool> modifyWalletName({required ABWalletInfo walletInfo, required String newName});

  /// 修改钱包密码
  Future<bool> modifyWalletPassword({
    required ABWalletInfo walletInfo,
    required String oldPassword,
    required String newPassword,
  });

  /// 验证钱包密码
  Future<bool> verifyWalletPassword({required ABWalletInfo walletInfo, required String password});
}
