import 'package:ecomm_assignment/screens/home/screen/product_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class CategoriesGrid extends StatefulWidget {
  const CategoriesGrid({super.key});

  @override
  State<CategoriesGrid> createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.categories.isEmpty) {
        return Center(
          child: Text(
            "No categories available",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.9, // Adjust to balance image and text proportions
          ),
          itemCount: homeController.categories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final category = homeController.categories[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductList(
                  categoryId: category.id!,
                  categoryName: category.name ?? 'Category',
                ));
              },

              child: Card(
                elevation: 6.0,
                shadowColor: Colors.black38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: category.image != null
                            ? Image.network(
                          category.image!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                    (progress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        )
                            : Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Category Title
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      right: 10.0,
                      child: Text(
                        category.name ?? 'Unknown',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(0.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
