import 'package:get/get.dart';
import '../../../utils/storage_service.dart';
import '../../home/models/product.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  final StorageService storageService = Get.find<StorageService>();
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  void _loadCartFromStorage() {
    try {
      final storedItems = storageService.getCartItems();
      if (storedItems != null) {
        cartItems.value = storedItems.map((item) => CartItem.fromJson(item)).toList();
      }
      _calculateTotal();
    } catch (e) {
      print('Error loading cart: $e');
      cartItems.value = [];  // Ensure empty list on error
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final itemsJson = cartItems.map((item) => item.toJson()).toList();
      await storageService.saveCartItems(itemsJson);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  void addToCart(Product product) {
    final existingItemIndex = cartItems.indexWhere(
            (item) => item.product.id == product.id
    );

    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product, quantity: 1));
    }

    _calculateTotal();
    _saveCartToStorage();
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
    _calculateTotal();
    _saveCartToStorage();
  }

  void updateQuantity(CartItem item, int quantity) {
    final index = cartItems.indexOf(item);
    if (index == -1) return;

    if (quantity < 1) {
      removeFromCart(item);
      return;
    }

    cartItems[index].quantity = quantity;
    cartItems.refresh();
    _calculateTotal();
    _saveCartToStorage();
  }

  void _calculateTotal() {
    total.value = cartItems.fold(
      0,
          (sum, item) => sum + (item.product.price! * item.quantity),
    );
  }

  void clearCart() {
    cartItems.clear();
    total.value = 0;
    _saveCartToStorage();
  }
}