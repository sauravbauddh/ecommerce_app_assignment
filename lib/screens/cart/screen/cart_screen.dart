import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../controller/cart_controller.dart';
import '../models/cart_item.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('shopping_cart')),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_shopping_cart),
            onPressed: controller.cartItems.isNotEmpty
                ? () => _showClearCartDialog(context)
                : null,
          ),
        ],
      ),
      body: Obx(() => _buildBody()),
      bottomNavigationBar: Obx(() => _buildBottomBar()),
    );
  }

  Widget _buildBody() {
    if (controller.cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Get.theme.disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              tr('empty_cart'),
              style: TextStyle(
                fontSize: 16,
                color: Get.theme.disabledColor,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text(tr('continue_shopping')),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: controller.cartItems.length,
      itemBuilder: (context, index) {
        final item = controller.cartItems[index];
        return _buildCartItem(item);
      },
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: item.product.images?.isNotEmpty == true
                    ? Image.network(
                  item.product.images![0]!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.error_outline),
                )
                    : const Icon(Icons.image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title ?? tr('unknown_product'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr('price_value', args: [item.product.price?.toStringAsFixed(2) ?? '0.00']),
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => controller.updateQuantity(
                    item,
                    item.quantity - 1,
                  ),
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => controller.updateQuantity(
                    item,
                    item.quantity + 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    if (controller.cartItems.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('total'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
                Text(
                  tr('price_value', args: [controller.total.toStringAsFixed(2)]),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Implement checkout
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(tr('proceed_to_checkout')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('clear_cart')),
        content: Text(tr('clear_cart_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearCart();
              Navigator.pop(context);
            },
            child: Text(tr('clear')),
          ),
        ],
      ),
    );
  }
}