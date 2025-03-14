import 'package:flutter/material.dart';

class ABCustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final ShapeBorder? shape;
  final Clip? clipBehavior;

  const ABCustomCard({
    required this.child,
    this.color,
    this.elevation,
    this.margin,
    this.padding,
    this.shape,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Theme.of(context).cardColor,
      elevation: elevation ?? 2.0,
      margin: margin ?? const EdgeInsets.all(8.0),
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: clipBehavior ?? Clip.none,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
