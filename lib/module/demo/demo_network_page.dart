import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_chain_manager/lib_chain_manager.dart';
import 'package:lib_uikit/lib_uikit.dart';

class DemoNetworkPage extends HookConsumerWidget {
  const DemoNetworkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chainInfoRead = ref.watch(chainInfoProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Demo Components Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("第一个链数据：\n ${chainInfoRead.first.toJson()}"),
            ElevatedButton(
              onPressed: () => {_getAllNetwork(chainInfoRead, context)},
              child: Text("网络数据长度:${chainInfoRead.length}"),
            ),
            ElevatedButton(
              onPressed: () => {_getLoadNetwork(chainInfoRead, context)},
              child: Text("模拟加载网络数据"),
            ),
          ],
        ),
      ),
    );
  }

  ///展示当前所有网络
  void _getAllNetwork(List<ABChainInfo> chainInfoRead, BuildContext context) {
    ABToast().showToast(
      context,
      ToastLevel.info,
      "当前链长度：${chainInfoRead.length}",
    );
  }

  /// 模拟网络请求
  void _getLoadNetwork(List<ABChainInfo> chainInfoRead, BuildContext context) {
    Future.delayed(const Duration(seconds:5),(){



    });
  }
}
