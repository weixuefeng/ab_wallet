import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_network/impl/ab_api_network_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:force_wallet/module/demo/demo_page.dart';
import 'package:force_wallet/repositry/transaction_repo.dart';

void main() async {
  runApp(ProviderScope(child: const MyApp()));
}

@riverpod
String helloWorld(Ref ref) {
  return 'Hello World';
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);
    // final String value = ref.watch(greetingProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    FlutterTrustWalletCore.init();
    var hd = HDWallet.createWithMnemonic(
      "gym avoid gentle stereo code yard kangaroo leisure merge piece permit inch",
    );
    var addr = hd.getAddressForCoin(TWCoinType.TWCoinTypeNewChain);
    var addr2 = hd.getAddressForCoin(TWCoinType.TWCoinTypeEthereum);
    ABLogger.d("addr is: " + addr + "\r\n eth: $addr2");
    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (
    //       BuildContext context,
    //       Animation<double> animation,
    //       Animation<double> secondaryAnimation,
    //     ) {
    //       return const DemoPage();
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
