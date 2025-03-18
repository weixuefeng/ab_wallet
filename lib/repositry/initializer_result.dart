class InitializerResult {
  final bool mmkvSuccess;
  final bool walletInfoSuccess;

  final bool haveLocalWalletInfo;
  final dynamic otherInfo;

  @override
  String toString() {
    return 'InitializerResult{mmkvSuccess: $mmkvSuccess, walletInfoSuccess: $walletInfoSuccess, haveLocalWalletInfo: $haveLocalWalletInfo, otherInfo: $otherInfo}';
  }

  InitializerResult({
    required this.mmkvSuccess,
    required this.walletInfoSuccess,
    required this.haveLocalWalletInfo,
    this.otherInfo,
  });
}
