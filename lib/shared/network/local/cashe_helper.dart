import 'package:shared_preferences/shared_preferences.dart';
class CasheHelper
{
  static late SharedPreferences sharedPreferences;
  static init () async
  {
     return sharedPreferences = await SharedPreferences.getInstance();
  }
  static Future <bool> putBool ({
    required String key,
    required bool value
  })
  async {
    return await sharedPreferences.setBool(key,value);
  }

  static dynamic getData ({
    required String key,
  })
  async
  {
    return  sharedPreferences.getBool(key)?? false;
  }


}