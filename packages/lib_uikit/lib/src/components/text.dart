// lib/src/components/text.dart
import 'package:flutter/material.dart';

class ABHeadingText extends StatelessWidget {
  final String text;
  final Color? color;

  const ABHeadingText({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: color),
    );
  }
}

class ABBodyText extends StatelessWidget {
  final String text;
  final Color? color;

  const ABBodyText({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
    );
  }
}
