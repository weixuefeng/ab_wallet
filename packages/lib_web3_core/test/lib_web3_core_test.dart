import 'package:flutter_test/flutter_test.dart';

import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';

void main() {
  test('addesss test', () {
    var addr = WalletMethodUtils.newAddressToHex("NEW182MGKFubHczKvEXiXdcZ7DH8phGQnumsAHZ");
    print("addr: $addr");
  });


  // group('MySingleton', () {
  //   test('should return correct singleton method result', () {
  //     // 获取单例实例
  //     final mySingleton = MySingleton();
  //
  //     // 调用单例方法
  //     final result = mySingleton.doSomething();
  //
  //     // 验证结果
  //     expect(result, "This is a singleton method.");
  //   });
  // });

}
