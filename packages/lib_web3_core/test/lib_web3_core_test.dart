import 'package:flutter_test/flutter_test.dart';

import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';

void main() {
  test('addesss test', () {
    var addr = WalletMethodUtils.newAddressToHex("NEW182MGKFubHczKvEXiXdcZ7DH8phGQnumsAHZ");
    print("addr: $addr");
  });
}
