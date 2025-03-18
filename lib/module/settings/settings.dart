import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:force_wallet/module/demo/demo_page.dart';
import 'package:lib_uikit/lib_uikit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.title});

  final String title;

  @override
  State<SettingPage> createState() => _HomePageState();
}

class _HomePageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(ABWalletS.current.ab_mine_setting)],
        ),
      ),
    );
  }
}
