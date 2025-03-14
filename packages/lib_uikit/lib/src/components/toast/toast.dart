import 'package:flutter/material.dart';

class ABCustomToast {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 14.0,
    ToastPosition position = ToastPosition.bottom,
  }) {
    // Create a OverlayEntry
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: 0,
            right: 0,
            bottom: position == ToastPosition.bottom ? 50 : null,
            top: position == ToastPosition.top ? 50 : null,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: textColor, fontSize: fontSize),
                  ),
                ),
              ),
            ),
          ),
    );

    // Insert into Overlay
    Overlay.of(context).insert(overlayEntry);

    // Delayed to remove
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

enum ToastPosition { top, bottom }
