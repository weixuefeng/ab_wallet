import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:flutter_trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:force_wallet/providers/locale_provider.dart';
import 'package:force_wallet/providers/theme_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lib_base/lib_base.dart';
import 'package:lib_chain_manager/mock/mock_ab_chain_manager_impl.dart';
import 'package:lib_storage/lib_storage.dart';
import 'package:lib_wallet_manager/impl/ab_wallet_manager.dart';
import 'package:lib_web3_core/impl/chain_method_impl.dart';
import 'package:lib_web3_core/lib_web3_core.dart';
import 'package:lib_web3_core/utils/wallet_method_extension.dart';
import 'package:lib_web3_core/utils/wallet_method_util.dart';
import 'package:lib_web3_interaction/chains/rpc/rpc_address_provider.dart';
import 'package:lib_web3_interaction/mock/mock_lib_ab_web3_core_module_impl.dart';

class DemoSettingPage extends HookConsumerWidget {
  const DemoSettingPage({super.key});

  static const String TAG = 'DemoSettingPage';



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider.notifier);
    final localeNotifier = ref.read(localeProvider.notifier);

    final themeMode = ref.watch(themeProvider);

    void setLanguageEn() async {
      localeNotifier.changeLocale(Locale.fromSubtags(languageCode: 'en'));
    }

    void setLanguageZh() async {
      localeNotifier.changeLocale(Locale.fromSubtags(languageCode: 'zh'));
    }

    void setDisplayMode() async {
      themeNotifier.toggleTheme();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Setting测试 Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(ABWalletS.current.ab_public_app_name),
            SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => {setLanguageEn()},
              child: Text("国际化测试-英文"),
            ),
            ElevatedButton(
              onPressed: () => {setLanguageZh()},
              child: Text("国际化测试-中文"),
            ),
            ElevatedButton(
              onPressed: () => {setDisplayMode()},
              child: Text(themeMode == ThemeMode.light ? "切换夜间" : "切换白天"),
            ),
          ],
        ),
      ),
    );
  }
}
