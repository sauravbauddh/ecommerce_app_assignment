import 'package:ecomm_assignment/screens/cart/controller/cart_controller.dart';
import 'package:get/get.dart';
import '../core/theme/theme_controller.dart';
import '../repo/language_rep.dart';
import '../screens/change_language/controller/language_controller.dart';
import '../screens/home/controller/home_controller.dart';
import '../utils/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ThemeController>(() => ThemeController());
    Get.lazyPut(() => SettingsController());
    Get.lazyPut<LanguageController>(
          () => LanguageController(repository: LanguageRepository()),
    );
    Get.lazyPut<CartController>(() => CartController());
  }
}