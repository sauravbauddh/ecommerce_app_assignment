import 'package:ecomm_assignment/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/storage_service.dart';
import '../models/user_preferences.dart';

class OnboardingController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();
  final TextEditingController nameController = TextEditingController();

  final RxInt currentPage = 0.obs;
  final RxString selectedGender = 'male'.obs;
  final RxBool enableNotifications = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkOnboardingStatus();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> checkOnboardingStatus() async {
    final completed = storageService.hasCompletedOnboarding();
    if (completed) {
      Get.offAllNamed(AppRoutes.HOME);
    }
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  Future<void> skipOnboarding() async {
    await storageService.setOnboardingCompleted(true);
    Get.offAllNamed(AppRoutes.HOME);
  }

  Future<void> completeOnboarding() async {
    final userPrefs = UserPreferences(
      name: nameController.text.trim(),
      gender: selectedGender.value,
      enableNotifications: enableNotifications.value,
    );

    await storageService.saveUserPreferences(userPrefs);
    await storageService.setOnboardingCompleted(true);
    Get.offAllNamed(AppRoutes.HOME);
  }
}