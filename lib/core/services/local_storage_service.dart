import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _genderKey = 'user_gender';
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> saveGender(String gender) async {
    log('LocalStorageService: Saving gender: $gender');
    await _prefs.setString(_genderKey, gender);
  }

  String? getGender() {
    final gender = _prefs.getString(_genderKey);
    log(
      'LocalStorageService: Retrieved gender from SharedPreferences: $gender',
    );
    return gender;
  }
}
