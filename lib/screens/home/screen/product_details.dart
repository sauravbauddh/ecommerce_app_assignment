import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../cart/controller/cart_controller.dart';
import '../models/product.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final Product product = Get.arguments as Product;
  late final CartController cartController;
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
  }

  void _addToCart() {
    cartController.addToCart(product);
    Get.snackbar(
      tr('added_to_cart'),
      tr('item_added_to_cart', args: [product.title ?? '']),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _buyNow() {
    cartController.addToCart(product);
    Get.toNamed('/cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title ?? tr('product_details'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        elevation: 0,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImages(),
            const SizedBox(height: 24.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                product.title ?? tr('unknown_product'),
                style: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                tr('price_value', args: [product.price?.toStringAsFixed(2) ?? '0.00']),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                tr('description'),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                product.description ?? tr('no_description'),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                tr('specifications'),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("- ${tr('material')}"),
                  Text("- ${tr('sizes')}"),
                  Text("- ${tr('colors')}"),
                  Text("- ${tr('warranty')}"),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductImages() {
    if (product.images != null && product.images!.isNotEmpty) {
      return Stack(
        children: [
          SizedBox(
            height: 350.0,
            child: PageView.builder(
              itemCount: product.images!.length,
              onPageChanged: (index) {
                setState(() {
                  currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'product-${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      product.images![index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (product.images!.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images!.length,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentImageIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    } else {
      return Container(
        height: 350.0,
        color: Colors.grey[200],
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 80.0,
            color: Theme.of(context).disabledColor,
          ),
        ),
      );
    }
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15.0,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 14.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart),
                label: Text(tr('add_to_cart')),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _buyNow,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 14.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag),
                label: Text(tr('buy_now')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}