import 'package:ecomm_assignment/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();

  final RxString currentTheme = 'system'.obs;
  final RxString currentLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    currentTheme.value = storageService.getThemeMode();
    currentLanguage.value = storageService.getLanguage();
    _applySettings();
  }

  Future<void> updateTheme(String themeMode) async {
    currentTheme.value = themeMode;
    await storageService.saveThemeMode(themeMode);
    _applySettings();
  }

  Future<void> updateLanguage(String languageCode) async {
    currentLanguage.value = languageCode;
    await storageService.saveLanguage(languageCode);
    _applySettings();
  }

  void _applySettings() {
    switch (currentTheme.value) {
      case 'light':
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 'dark':
        Get.changeThemeMode(ThemeMode.dark);
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
    }
    Get.updateLocale(Locale(currentLanguage.value));
  }
}