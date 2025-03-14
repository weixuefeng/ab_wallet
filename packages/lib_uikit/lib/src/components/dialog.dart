import 'package:flutter/material.dart';

class ABCustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  const ABCustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.backgroundColor,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }
}
