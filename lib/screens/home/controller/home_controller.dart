import 'package:ecomm_assignment/screens/home/models/offer.dart';
import 'package:get/get.dart';

import '../../../network/service_exception.dart';
import '../../../repo/category_repo.dart';
import '../../../repo/offer_repo.dart';
import '../../../repo/product_repo.dart';
import '../../../utils/logger.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeController extends GetxController {

  RxList<Product> productList = <Product>[].obs;
  RxList<Category> categories = <Category>[].obs;
  RxList<Offer> offers = <Offer>[].obs;
  RxString errorMessage = "".obs;
  RxList<Product>productListFiltered = <Product>[].obs;
  var isLoadingOffers = true.obs;
  var isLoadingCategories = true.obs;

  @override
  void onInit() {
    super.onInit();
    getProducts();
    getCategories();
    getOffers();
  }

  Future<void> getProducts() async {
    try {
      var response = await ProductRepository.getProducts();
      if (response != null) {
        productList.value = response;
        isLoadingOffers.value = false;
      } else {
        logger.w("No products found.");
      }
    } on RepoServiceException catch (e) {
      logger.e(e.message);
      errorMessage.value = e.message!;
    }
  }

  Future getProductsByCategory(String categoryId) async {
    try {
      print("GetPbyC");
      var response = await ProductRepository.getProductsByCategory(categoryId);
      if (response != null) {
        productList.value = response;
      } else {
        productList.clear();
      }
    } on RepoServiceException catch (e) {
      logger.e(e.message);
      errorMessage.value = e.message!;
    }
  }

  Future<void> getCategories() async {
    try {
      var response = await CategoryRepository.getCategories();
      if (response != null) {
        categories.value = response.where((category) => category.name != "string").toList();
        isLoadingCategories.value = false;
      } else {
        logger.w("No categories found.");
      }
    } on RepoServiceException catch (e) {
      logger.e(e.message);
      errorMessage.value = e.message!;
    }
  }

  Future<void> getOffers() async {
    try {
      var response = await OfferRepository.getOffers();
      if (response != null) {
        offers.value = response; // Update offers
      } else {
        logger.w("No offers found.");
      }
    } on RepoServiceException catch (e) {
      logger.e(e.message);
      errorMessage.value = e.message!;
    }
  }

  Future<void> reloadAllData() async {
    await Future.wait([getProducts(), getCategories(), getOffers()]);
  }

}
