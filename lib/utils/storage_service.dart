import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/onboarding/models/user_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  static const String THEME_KEY = 'theme_mode';
  static const String LANGUAGE_KEY = 'language';
  static const String CART_ITEMS_KEY = 'cart_items';
  static const String ONBOARDING_COMPLETED_KEY = 'onboarding_completed';
  static const String USER_PREFERENCES_KEY = 'user_preferences';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(THEME_KEY, themeMode);
  }

  String getThemeMode() {
    return _prefs.getString(THEME_KEY) ?? 'system';
  }

  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(LANGUAGE_KEY, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(LANGUAGE_KEY) ?? 'en';
  }

  Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    await _prefs.setString(CART_ITEMS_KEY, jsonEncode(items));
  }

  bool hasCompletedOnboarding() {
    return _prefs.getBool(ONBOARDING_COMPLETED_KEY) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(ONBOARDING_COMPLETED_KEY, completed);
  }

  Future<void> saveUserPreferences(UserPreferences prefs) async {
    await _prefs.setString(USER_PREFERENCES_KEY, jsonEncode(prefs.toJson()));
  }

  UserPreferences? getUserPreferences() {
    final String? data = _prefs.getString(USER_PREFERENCES_KEY);
    if (data == null) return null;

    try {
      return UserPreferences.fromJson(jsonDecode(data));
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
      return null;
    }
  }

  List<Map<String, dynamic>>? getCartItems() {
    final String? jsonString = _prefs.getString(CART_ITEMS_KEY);
    if (jsonString == null) return null;

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      print('Error decoding cart items: $e');
      return null;
    }
  }
}