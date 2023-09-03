import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

import '../constant/language_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";

const String PREFS_KEY_DARK = "PREFS_KEY_DARK";

const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";

const String PREFS_KEY_IS_USER_OPENED_REGISTER = "PREFS_KEY_IS_USER_OPENED_REGISTER";

const String LOGGED_IN_TOKEN = "LOGGED_IN_TOKEN";
const String USER_NAME = "USER_NAME";
const String PASS = "PASS";

const String PREFS_KEY_BUSINESS_TYPE = "PREFS_KEY_BUSINESS_TYPE";

const String PREFS_KEY_DECIMAL_PLACES = "PREFS_KEY_DECIMAL_PLACES";
const String PREFS_KEY_LOCATION_ID = "PREFS_KEY_LOCATION_ID";
const String PREFS_KEY_TAX_VALUE = "PREFS_KEY_TAX_VALUE";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  static bool isLangChanged = false;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      // return default lang
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      print('arabic');
      // set english
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
      isLangChanged = false;
    } else {
      print('english');
      // set arabic
      _sharedPreferences.setString(
          PREFS_KEY_LANG, LanguageType.ARABIC.getValue());
      isLangChanged = true;
    }
  }

  Future<Locale> getLocal() async {
    String currentLang = await getAppLanguage();

    if (currentLang == LanguageType.ARABIC.getValue()) {
      isLangChanged = true;
      return ARABIC_LOCAL;
    } else {
      isLangChanged = false;
      return ENGLISH_LOCAL;
    }
  }

  // Theme
  Future<void> changeTheme(bool themeValue) async {
    _sharedPreferences.setBool(PREFS_KEY_DARK, themeValue);
  }

  Future<bool> isThemeDark() async {
    return _sharedPreferences.getBool(PREFS_KEY_DARK) ?? false;
  }

  //login
  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }

  //user opened register
  Future<void> setUserOpenedRegister() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_OPENED_REGISTER, true);
  }

  Future<bool> isUserOpenedRegister() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_OPENED_REGISTER) ?? false;
  }

  Future<void> userClosedRegister() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_OPENED_REGISTER);
  }

  //Token
  Future<bool> setToken(String key, String token) async {
    return await _sharedPreferences.setString(key, token);
  }

  String? getToken(String key) {
    return _sharedPreferences.getString(key);
  }

  // business type
  Future<bool> setBusinessType(String key, String businessType) async {
    return await _sharedPreferences.setString(key, businessType);
  }

  String? getBusinessType(String key) {
    return _sharedPreferences.getString(key);
  }

  // user name
  Future<bool> setUserName(String key, String userName) async {
    return await _sharedPreferences.setString(key, userName);
  }

  String? getUserName(String key) {
    return _sharedPreferences.getString(key);
  }

  // password
  Future<bool> setPassword(String key, String password) async {
    return await _sharedPreferences.setString(key, password);
  }

  String? getPassword(String key) {
    return _sharedPreferences.getString(key);
  }

  // location_id
  Future<bool> setLocationId(String key, int locationId) async {
    return await _sharedPreferences.setInt(key, locationId);
  }

  int? getLocationId(String key) {
    return _sharedPreferences.getInt(key);
  }

  Future<void> removeLocationId(String key) async {
    _sharedPreferences.remove(key);
  }

  // decimal_places
  Future<bool> setDecimalPlaces(String key, int decimalPlaces) async {
    return await _sharedPreferences.setInt(key, decimalPlaces);
  }

  int? getDecimalPlaces(String key) {
    return _sharedPreferences.getInt(key);
  }

  Future<void> removeDecimalPlaces(String key) async {
    _sharedPreferences.remove(key);
  }

  // tax value
  Future<bool> setTaxValue(String key, int taxValue) async {
    return await _sharedPreferences.setInt(key, taxValue);
  }

  int? getTaxValue(String key) {
    return _sharedPreferences.getInt(key);
  }

  Future<void> removeTaxValue(String key) async {
    _sharedPreferences.remove(key);
  }
}