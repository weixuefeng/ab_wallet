

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreStorageKeys{
  static const String abPreKey = "ab_pre_key";
  static const int abPreGreenUpValue = 0;
  static const int abPreRedUpValue = 1;
}

class PreferencesNotifier extends StateNotifier<int>{
  PreferencesNotifier() : super(PreStorageKeys.abPreGreenUpValue);

  void setPre(int preType){
    state = preType;
  }
}

final preferencesProvider = StateNotifierProvider<PreferencesNotifier,int>((ref){
  return PreferencesNotifier();
});