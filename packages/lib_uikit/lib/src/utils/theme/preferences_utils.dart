
import 'package:lib_base/lib_base.dart';
import 'package:lib_uikit/providers/preferences_provider.dart';

class PreferencesUtils {

  static int getCurrentPreType(){
    return abGlobalProviderContainer.read(preferencesProvider);
  }

}