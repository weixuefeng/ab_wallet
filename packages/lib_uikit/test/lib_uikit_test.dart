import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_uikit/lib_uikit.dart';

void main() {
  testWidgets('PrimaryButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ABPrimaryButton(text: 'Click Me', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Click Me'), findsOneWidget);
  });
}
