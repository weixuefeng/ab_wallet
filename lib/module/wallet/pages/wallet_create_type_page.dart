import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WalletCreateTypePage extends HookConsumerWidget{
  const WalletCreateTypePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text('选择创建钱包方式页面');
  }

}