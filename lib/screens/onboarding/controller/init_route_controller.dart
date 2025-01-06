import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/storage_service.dart';

class InitialRouteController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();

  @override
  void onReady() {
    super.onReady();
    checkInitialRoute();
  }

  void checkInitialRoute() {
    final initialRoute = storageService.hasCompletedOnboarding()
        ? AppRoutes.HOME
        : AppRoutes.ONBOARDING;
    Get.offAllNamed(initialRoute);
  }
}
