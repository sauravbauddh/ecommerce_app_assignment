
import 'package:get/get.dart';

import '../../../repo/language_rep.dart';

class LanguageController extends GetxController {
  final LanguageRepository repository;

  var currentLanguage = ''.obs;

  LanguageController({required this.repository});

  @override
  void onInit() async {
    super.onInit();
    currentLanguage.value = await getCurrentLanguage();
  }

  Future<String> getCurrentLanguage() async {
    return repository.getCurrentLanguage();
  }

  void updateLanguage(String languageCode) async {
    await repository.changeLanguage(languageCode);
    currentLanguage.value = languageCode;
  }
}
