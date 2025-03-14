import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_wallet/common/app_initializer.dart';

final appBeforeHomePageInitializerProvider =
    Provider<AppBeforeHomePageInitializer>((ref) {
      return AppBeforeHomePageInitializer();
    });

final initializationProvider = FutureProvider<void>((ref) async {
  final initialize = ref.read(appBeforeHomePageInitializerProvider);
  await initialize.initialize();
});
