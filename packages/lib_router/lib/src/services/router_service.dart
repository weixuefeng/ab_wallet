import 'package:go_router/go_router.dart';

class RouterService {
  // Encapsulates go_router navigation methods

  final GoRouter router;

  RouterService(this.router);

  void go(String path, {Object? extra}) {
    router.go(path, extra: extra);
  }

  void push(String path, {Object? extra}) {
    router.push(path, extra: extra);
  }

  void pop() {
    router.pop();
  }

  void replace(String path, {Object? extra}) {
    router.replace(path, extra: extra);
  }
}
