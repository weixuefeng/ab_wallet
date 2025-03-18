
import 'package:lib_uikit/providers/global_provider.dart';
import 'package:lib_uikit/providers/preferences_provider.dart';

class PreferencesUtils {

  static int getCurrentPreType(){
    return globalProviderContainer.read(preferencesProvider);
  }

}