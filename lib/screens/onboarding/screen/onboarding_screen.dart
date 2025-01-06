import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/storage_service.dart';
import '../../change_language/controller/language_controller.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();
  final themeController = Get.find<ThemeController>();
  final langController = Get.find<LanguageController>();
  final storageService = Get.find<StorageService>();

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView(
            controller: pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              OnboardingPage(
                imageUrl: 'https://images.unsplash.com/photo-1557683316-973673baf926',
                title: tr('onboarding_title_1'),
                description: tr('onboarding_desc_1'),
              ),
              OnboardingPage(
                imageUrl: 'https://images.unsplash.com/photo-1534126511673-b6899657816a',
                title: tr('onboarding_title_2'),
                description: tr('onboarding_desc_2'),
              ),
              _buildPersonalizationPage(context),
            ],
          ),

          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: controller.skipOnboarding,
              child: Text(
                tr('skip'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Theme.of(context).primaryColor,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Visibility(
                        visible: controller.currentPage.value > 0,
                        child: TextButton(
                          onPressed: () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(tr('back')),
                        ),
                      )),
                      Obx(() => ElevatedButton(
                        onPressed: () {
                          if (controller.currentPage.value < 2) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            controller.completeOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          controller.currentPage.value < 2
                              ? tr('next')
                              : tr('get_started'),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizationPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tr('personalize_experience'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: tr('your_name'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: controller.selectedGender.value,
            decoration: InputDecoration(
              labelText: tr('gender'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              DropdownMenuItem(
                value: 'male',
                child: Text(tr('male')),
              ),
              DropdownMenuItem(
                value: 'female',
                child: Text(tr('female')),
              ),
              DropdownMenuItem(
                value: 'other',
                child: Text(tr('other')),
              ),
            ],
            onChanged: (value) {
              controller.selectedGender.value = value!;
            },
          ),
          const SizedBox(height: 16),
          Obx(() => SwitchListTile(
            title: Text(tr('notifications')),
            subtitle: Text(tr('notifications_desc')),
            value: controller.enableNotifications.value,
            onChanged: (value) {
              controller.enableNotifications.value = value;
            },
          )),
          const SizedBox(height: 24),

          // Change Language Button
          ElevatedButton(
            onPressed: () {
              _showLanguageDialog(context);
            },
            child: Text(tr('change_language')),
          ),
          const SizedBox(height: 16),

          // Change Theme Button
          ElevatedButton(
            onPressed: () {
              _showThemeDialog(context);
            },
            child: Text(tr('change_theme')),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    await Get.toNamed(AppRoutes.CHANGE_LANG);
    await storageService.saveLanguage(
        langController.currentLanguage.value
    );
  }

  Future<void> _showThemeDialog(BuildContext context) async {
    final currentTheme = storageService.getThemeMode();
    final newTheme = currentTheme == 'dark' ? 'light' : 'dark';
    await storageService.saveThemeMode(newTheme);
    if (newTheme == 'dark') {
      await themeController.switchToDarkTheme();
      Get.forceAppUpdate();
    } else {
      await themeController.switchToLightTheme();
      Get.forceAppUpdate();
    }
  }
}
