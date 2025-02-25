import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dodjaerrands_driver/core/helper/shared_preference_helper.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  void _loadCurrentTheme() {
    _darkTheme = sharedPreferences.getBool(SharedPreferenceHelper.theme) ?? true;
    update();
  }
}
