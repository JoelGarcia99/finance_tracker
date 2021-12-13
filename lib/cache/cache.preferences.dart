
import 'dart:convert';

import 'package:finance_tracker/auth/models/model.user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachePreferences {

  static CachePreferences? _instance;

  factory CachePreferences() {
    _instance ??= CachePreferences._();

    return _instance!;
  }

  CachePreferences._();

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  UserModel? get user {
    final jsonString = _prefs.getString('user');
    
    if(jsonString == null || jsonString.isEmpty) return null;

    return UserModel.fromJSON(json.decode(jsonString));
  }

  set user(UserModel? user) => _prefs.setString('user', user!=null? user.toJSONString():'');
}