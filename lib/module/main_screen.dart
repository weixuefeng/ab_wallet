import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:force_wallet/module/home/home_page.dart';
import 'package:force_wallet/module/settings/settings_page.dart';
import 'package:lib_router/lib_router_exports.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  MainScreen({required this.child, required this.state, super.key});

  final List<Widget> _pages = [
    HomePage(title: ABWalletS.current.ab_home_home_page),
    SettingPage(title: ABWalletS.current.ab_mine_setting),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: ABTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Setting',
          ),
        ],
        currentIndex: _calculateCurrentIndex(state),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}

int _calculateCurrentIndex(GoRouterState state) {
  if (state.uri.path == '/') {
    return 0;
  } else if (state.uri.path == '/settings') {
    return 1;
  }
  return 0;
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go('/');
      break;
    case 1:
      context.go('/settings');
      break;
  }
}
