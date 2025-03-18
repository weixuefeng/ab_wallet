import 'package:flutter_test/flutter_test.dart';
import 'package:lib_router/lib_router.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('RouterConfig builds GoRouter', () {
    final config = LibRouterConfig(routes: []);
    expect(config.buildRouter(), isA<GoRouter>());
  });
}
