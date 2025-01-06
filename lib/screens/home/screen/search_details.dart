import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../routes/app_routes.dart';
import '../controller/home_controller.dart';
import '../models/product.dart';

class SearchDetailsScreen extends StatefulWidget {
  final String query;

  const SearchDetailsScreen({super.key, required this.query});

  @override
  _SearchDetailsScreenState createState() => _SearchDetailsScreenState();
}

class _SearchDetailsScreenState extends State<SearchDetailsScreen> {
  List<Product> searchResults = [];
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    searchResults = performSearch(widget.query);
  }

  List<Product> performSearch(String query) {
    List<Product> allProducts = homeController.productList.value;
    return allProducts
        .where((product) =>
        product.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr('search_results_for', args: [widget.query]),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        elevation: 1.0,
      ),
      body: searchResults.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              tr('no_results_found'),
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).disabledColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tr('try_different_search'),
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final product = searchResults[index];
            return _buildProductCard(product);
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: 60.0,
            height: 60.0,
            child: product.images?.isNotEmpty == true
                ? Image.network(
              product.images![0]!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Theme.of(context).disabledColor.withOpacity(0.1),
                child: Icon(
                  Icons.image_not_supported,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            )
                : Container(
              color: Theme.of(context).disabledColor.withOpacity(0.1),
              child: Icon(
                Icons.image,
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
        ),
        title: Text(
          product.title ?? tr('unknown_product'),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          tr('price_value', args: [product.price?.toStringAsFixed(2) ?? '0.00']),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onTap: () {
          Get.toNamed(AppRoutes.PRODUCT_DETAILS, arguments: product);
        },
      ),
    );
  }
}