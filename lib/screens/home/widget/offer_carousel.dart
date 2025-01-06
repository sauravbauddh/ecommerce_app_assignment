import 'package:ecomm_assignment/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferCarousel extends StatefulWidget {
  const OfferCarousel({super.key});

  @override
  State<OfferCarousel> createState() => _OfferCarouselState();
}

class _OfferCarouselState extends State<OfferCarousel> {
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.offers.isEmpty) {
        return const Center(
          child: Text(
            "No offers available",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        );
      }

      return SizedBox(
        height: 240.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: homeController.offers.length,
          itemBuilder: (context, index) {
            final offer = homeController.offers[index];
            return GestureDetector(
              onTap: () {
                print("Offer clicked: ${offer.title}");
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                elevation: 6.0,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  width: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: offer.imageUrl.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(offer.imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        offer.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white ,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      if (offer.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            offer.subtitle!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
