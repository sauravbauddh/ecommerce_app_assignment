import 'package:ecomm_assignment/core/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  Future<void> switchToDarkTheme() async {
    isDarkMode.value = true;
    Get.changeThemeMode(ThemeMode.dark);
    Get.changeTheme(ThemeData.dark());
  }

  Future<void> switchToLightTheme() async {
    isDarkMode.value = false;
    Get.changeThemeMode(ThemeMode.light);
    Get.changeTheme(ThemeData.light());
  }

  Future<void> toggleTheme() async {
    if (isDarkMode.value) {
      await switchToLightTheme();
    } else {
      await switchToDarkTheme();
    }
  }
}