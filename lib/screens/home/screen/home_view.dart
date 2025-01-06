import 'package:ecomm_assignment/screens/cart/controller/cart_controller.dart';
import 'package:ecomm_assignment/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/theme/theme_controller.dart';
import '../../../routes/app_routes.dart';
import '../../change_language/controller/language_controller.dart';
import '../controller/home_controller.dart';
import '../widget/categories_grid.dart';
import '../widget/drawer.dart';
import '../widget/offer_carousel.dart';
import '../widget/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();
  final themeController = Get.find<ThemeController>();
  final langController = Get.find<LanguageController>();
  final storageService = Get.find<StorageService>();
  final cartController = Get.find<CartController>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedSettings();
    });
    homeController.getProducts();
    homeController.getCategories();
  }

  Future<void> _loadSavedSettings() async {
    final savedTheme = storageService.getThemeMode();
    if (savedTheme == 'dark') {
      themeController.switchToDarkTheme();
    } else {
      themeController.switchToLightTheme();
    }

    final savedLang = storageService.getLanguage();
    if (savedLang.isNotEmpty) {
      langController.updateLanguage(savedLang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          tr('app_title'), // Add 'app_title' to translations
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Get.toNamed('/cart'),
              ),
              Obx(() {
                final itemCount = cartController.cartItems.length;
                if (itemCount == 0) return const SizedBox.shrink();
                return Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      drawer: DrawerWidget(
        userName: storageService.getUserPreferences()?.name ?? 'User',
        onHomePressed: () => Get.back(),
        onOrdersPressed: () => Get.back(),
        onSettingsPressed: () => Get.back(),
        onLogoutPressed: () => Get.back(),
        onThemeChanged: () async {
          final currentTheme = storageService.getThemeMode();
          print(currentTheme);
          final newTheme = currentTheme == 'dark' ? 'light' : 'dark';
          await storageService.saveThemeMode(newTheme);
          if (newTheme == 'dark') {
            await themeController.switchToDarkTheme();
          } else {
            await themeController.switchToLightTheme();
          }
        },
        onLanguageChanged: () async {
          await Get.toNamed(AppRoutes.CHANGE_LANG);
          await storageService.saveLanguage(
              langController.currentLanguage.value
          );
        },
      ),
      body: ListView(
        children: [
          Searchbar(context: context),

          Obx(() => homeController.isLoadingOffers.value
              ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 150,
              margin: const EdgeInsets.all(12),
              color: Colors.grey[300],
            ),
          )
              : OfferCarousel()),

          const SizedBox(height: 20),

          Obx(() => homeController.isLoadingCategories.value
              ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  margin: const EdgeInsets.all(8),
                  color: Colors.grey[300],
                );
              },
            ),
          )
              : CategoriesGrid()),
        ],
      ),
    );
  }
}