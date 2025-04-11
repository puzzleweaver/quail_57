import 'package:shared_preferences/shared_preferences.dart';

class StaticPersistence {
  static SharedPreferences? sp;

  static SharedPreferences get _prefs {
    SharedPreferences? ret = sp;
    if (ret == null) {
      throw UnimplementedError(
        "Make sure to call StaticSharedPreferences.init before accessing settings :P",
      );
    }
    return ret;
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static void setInt(String key, int newValue) {
    _prefs.setInt(key, newValue);
  }

  static Future<void> init() async {
    sp = await SharedPreferences.getInstance();
    return;
  }
}
