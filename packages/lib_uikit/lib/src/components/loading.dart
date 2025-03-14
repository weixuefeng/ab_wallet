import 'package:flutter/material.dart';

class ABLoading extends StatelessWidget {
  final Color? color;
  final double? size;
  final String? message;

  const ABLoading({this.color, this.size = 40.0, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
              strokeWidth: 4.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(message!, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ],
      ),
    );
  }
}
