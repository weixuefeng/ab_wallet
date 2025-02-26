import 'package:lib_wallet_manager/model/ab_wallet_info.dart';

abstract class ABWalletManagerInterface {
  /// 获取所有钱包信息
  Future<List<ABWalletInfo>> getAllWalletInfos();

  /// 设置当前选中的钱包信息
  Future<bool> setSelectedWalletInfo(ABWalletInfo info);

  /// 获取当前选中的钱包信息
  Future<ABWalletInfo?> getSelectedWalletInfo();

  /// 设置 DApp 当前选中的钱包信息
  Future<bool> setDAppSelectedWalletInfo(ABWalletInfo info);

  /// 获取DApp当前选中的钱包信息
  Future<ABWalletInfo?> getDAppSelectedWalletInfo();

  /// 创建钱包
  Future<ABWalletInfo?> createWallet(String walletName, String password);

  /// 删除钱包
  Future<bool> deleteWallet(ABWalletInfo walletInfo);

  /// 导入钱包
  Future<ABWalletInfo?> importWallet(
    String walletName,
    String privateKey,
    String password,
  );

  /// 导出钱包
  Future<String?> exportWallet(ABWalletInfo walletInfo, String password);

  /// 修改钱包名称
  Future<bool> modifyWalletName(ABWalletInfo walletInfo, String newName);

  /// 修改钱包密码
  Future<bool> modifyWalletPassword(
    ABWalletInfo walletInfo,
    String newPassword,
  );

  /// 验证钱包密码
  Future<bool> verifyWalletPassword(ABWalletInfo walletInfo, String password);

  /// 获取钱包余额
  Future<String> getWalletBalance(ABWalletInfo walletInfo);
}
