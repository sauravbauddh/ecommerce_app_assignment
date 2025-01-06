import 'package:ecomm_assignment/screens/cart/screen/cart_screen.dart';
import 'package:ecomm_assignment/screens/home/screen/product_details.dart';
import 'package:get/get.dart';
import '../screens/change_language/screen/change_language_screen.dart';
import '../screens/home/screen/home_view.dart';
import '../screens/onboarding/screen/onboarding_screen.dart';
import 'app_routes.dart';
import 'bindings.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.CHANGE_LANG,
      page: () => LanguageSwitcherView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.PRODUCT_DETAILS,
      page: () => ProductDetails(),
      binding: InitialBinding()
    ),
    GetPage(
      name: AppRoutes.CART_PAGE,
      page: () => CartScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => OnboardingScreen(),
    ),
  ];
}
