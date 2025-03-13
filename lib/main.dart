import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:force_wallet/module/demo/demo_page.dart';
import 'package:force_wallet/providers/theme_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'providers/locale_provider.dart';

void main() {
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
    
   final locale =  ref.watch(localeProvider);
   final themeMode =  ref.watch(themeProvider);
   final themeNotifier = ref.read(themeProvider.notifier);
    
    final counter = useState(0);
    ABWalletS.load(Locale.fromSubtags(languageCode: 'en'));

    // final String value = ref.watch(greetingProvider);
    return MaterialApp(
      title: ABWalletS.current.ab_home_home_page,
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      supportedLocales: ABWalletS.delegate.supportedLocales,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ABWalletS.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: MyHomePage(title:  ABWalletS.current.ab_home_home_page),
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
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const DemoPage();
        },
      ),
    );
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
             Text(ABWalletS.current.ab_home_home_page),
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
