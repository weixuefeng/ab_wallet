import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:force_wallet/generated/l10n.dart';
import 'package:force_wallet/module/home/home_page.dart';
import 'package:force_wallet/module/settings/settings.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(title: ABWalletS.current.ab_home_home_page),
    SettingPage(title: ABWalletS.current.ab_mine_setting),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
