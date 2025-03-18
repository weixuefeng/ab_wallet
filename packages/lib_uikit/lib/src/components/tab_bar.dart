import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ABTabBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const ABTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.systemGrey.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: backgroundColor ?? CupertinoColors.systemBackground,
        selectedItemColor: activeColor ?? CupertinoColors.activeBlue,
        unselectedItemColor: inactiveColor ?? CupertinoColors.systemGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
