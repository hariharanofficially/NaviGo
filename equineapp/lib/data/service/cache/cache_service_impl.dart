import 'package:shared_preferences/shared_preferences.dart';

import 'cache_service.dart';

class CacheServiceImpl extends CacheService {
  @override
  Future<String> getString({required String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(name) ?? "";
  }

  @override
  void setString({required String name, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
  }

  @override
  Future<int> getInt({required String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(name) ?? 0;
  }

  @override
  void setInt({required String name, required int value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(name, value);
  }

  @override
  Future<bool> getBoolean({required String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(name) ?? false;
  }

  @override
  void setBoolean({required String name, required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, value);
  }

  @override
  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}