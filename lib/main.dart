import 'package:easy_localization/easy_localization.dart';
import 'package:ecomm_assignment/network/api_client.dart';
import 'package:ecomm_assignment/routes/bindings.dart';
import 'package:ecomm_assignment/routes/app_pages.dart';
import 'package:ecomm_assignment/routes/app_routes.dart';
import 'package:ecomm_assignment/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/theme_controller.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await ApiClient.init();
    await Get.putAsync(() => StorageService().init());

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('hi')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

String checkInitialRoute() {
  final storageService = Get.find<StorageService>();
  return storageService.hasCompletedOnboarding()
      ? AppRoutes.HOME
      : AppRoutes.ONBOARDING;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: checkInitialRoute(),
      getPages: AppPages.routes,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      fallbackLocale: const Locale('en'),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.isDarkMode.value
          ? ThemeMode.dark
          : ThemeMode.light,
    ));
  }
}