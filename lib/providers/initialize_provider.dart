import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_wallet/common/app_initializer.dart';
import 'package:force_wallet/repositry/initializer_result.dart';

final appBeforeHomePageInitializerProvider =
    Provider<AppBeforeHomePageInitializer>((ref) {
      return AppBeforeHomePageInitializer();
    });

final initializationProvider = FutureProvider<InitializerResult>((ref) async {
  final initialize = ref.read(appBeforeHomePageInitializerProvider);
 return await initialize.initialize();
});
