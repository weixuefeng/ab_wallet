// lib/src/components/buttons.dart
import 'package:flutter/material.dart';

class ABPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const ABPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}

class ABSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ABSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(text));
  }
}

class ABCustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;

  const ABCustomIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.iconSize,
    this.padding,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color ?? Theme.of(context).colorScheme.primary,
      iconSize: iconSize ?? 24.0,
      padding: padding ?? const EdgeInsets.all(8.0),
      tooltip: tooltip,
    );
  }
}
