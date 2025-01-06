import 'dart:ui';

import 'package:get/get.dart';

class LanguageRepository {

  Future<void> changeLanguage(String languageCode) async {
    Get.updateLocale(Locale(languageCode));
  }

  String getCurrentLanguage() {
    return Get.locale?.languageCode ?? 'en';
  }
}
