import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lib_base/provider/ab_navigator_provider.dart';

enum ToastLevel {
  success,
  error,
  warning,
  info,
}

class ABToast  {
  static final ABToast _instance = ABToast._internal();

  factory ABToast() => _instance;

  ABToast._internal();

  void showToast(BuildContext? context, ToastLevel level, String? message) {
    if (message != null && message.isNotEmpty) {
      _CustomToast().showToast(context, level, message,
          duration: message.length > 30 ? const Duration(milliseconds: 3500) : const Duration(seconds: 2),
      );
    }
  }
}

class _CustomToast {
  String? _lastMessage;
  DateTime? _lastToastTime;
  OverlayEntry? _lastOverlayEntry;
  static final _CustomToast _instance = _CustomToast._internal();

  factory _CustomToast() => _instance;

  _CustomToast._internal();

  void showToast(BuildContext? context, ToastLevel level, String message,
      {Duration duration = const Duration(seconds: 2), bool? forceEnglish = false}) {

    OverlayState? overlayState;
    if (context != null) {
      overlayState = Overlay.of(context);
    } else {
      overlayState = ABNavigatorProvider.navigatorKey.currentState?.overlay;
    }
    //when OverlayState is null，not show toast
    if (overlayState == null) {
      return;
    }

    final currentTime = DateTime.now();
    if (message == _lastMessage) {
      if (message.length <= 30) {
        if (_lastToastTime != null && currentTime.difference(_lastToastTime!) < const Duration(seconds: 2)) {
          return;
        }
      } else {
        if (_lastToastTime != null && currentTime.difference(_lastToastTime!) < const Duration(milliseconds: 3500)) {
          return;
        }
      }
    }
    _lastOverlayEntry?.remove();
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return _buildToastWidget(context, level, message, forceEnglish ?? false);
      },
    );
    overlayState.insert(overlayEntry);
    _lastOverlayEntry = overlayEntry;
    _lastMessage = message;
    _lastToastTime = currentTime;
    Timer(duration, () {
      if (_lastOverlayEntry != null) {
        _lastOverlayEntry!.remove();
        _lastOverlayEntry = null;
      }
    });
  }

  Widget _buildToastWidget(BuildContext context, ToastLevel level, String message, bool forceEnglish) {
   
    bool  isContainsChinese = false;
    IconData? iconData;
    // switch (level) {
    //   case ToastLevel.error:
    //     iconData = IconData();
    //     break;
    //   case ToastLevel.success:
    //     iconData = IconData;
    //     break;
    //   case ToastLevel.warning:
    //     iconData = IconData;
    //     break;
    //   default:
    //     iconData = null;
    //     break;
    // }
    final icon = iconData != null
        ? Icon(
      iconData,
      size: 16,
      color: Color(0xFF42A5F5),
    )
        : null;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(
            maxWidth: 279,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF42A5F5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Transform.translate(
                  offset: Offset(0, isContainsChinese ? 2 : 0),
                  child: icon,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Transform.translate(
                  offset: Offset(0, isContainsChinese ? -1 : 0),
                  child: Text(
                    textHeightBehavior:
                    const TextHeightBehavior(applyHeightToLastDescent: false, applyHeightToFirstAscent: false),
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ).copyWith(height: 1.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
