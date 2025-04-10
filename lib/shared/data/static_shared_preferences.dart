import 'package:shared_preferences/shared_preferences.dart';

class StaticSharedPreferences {
  static SharedPreferences? sp;

  static SharedPreferences get prefs {
    SharedPreferences? ret = sp;
    if (ret == null) {
      throw UnimplementedError(
        "Make sure to call StaticSharedPreferences.init before accessing settings :P",
      );
    }
    return ret;
  }

  static Future<void> init() async {
    sp = await SharedPreferences.getInstance();
    return;
  }
}
