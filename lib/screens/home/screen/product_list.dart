import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../routes/app_routes.dart';
import '../controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product.dart';

class ProductList extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductList({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final homeController = Get.find<HomeController>();
  final sortOptions = [
    'sort_price_low_high',
    'sort_price_high_low',
    'sort_name_a_z',
    'sort_name_z_a',
  ];

  String selectedSortOption = 'sort_price_low_high';
  RangeValues priceRange = const RangeValues(0, 1000);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    setState(() => isLoading = true);
    await homeController.getProductsByCategory(widget.categoryId.toString());
    homeController.productListFiltered = homeController.productList;
    setState(() => isLoading = false);
  }

  void _applyFilters() {
    final baseList = [...homeController.productList];
    var filteredList = baseList.where((product) {
      return product.price! >= priceRange.start &&
          product.price! <= priceRange.end;
    }).toList();

    switch (selectedSortOption) {
      case 'sort_price_low_high':
        filteredList.sort((a, b) => a.price!.compareTo(b.price!));
      case 'sort_price_high_low':
        filteredList.sort((a, b) => b.price!.compareTo(a.price!));
      case 'sort_name_a_z':
        filteredList.sort((a, b) => a.title!.compareTo(b.title!));
      case 'sort_name_z_a':
        filteredList.sort((a, b) => b.title!.compareTo(a.title!));
    }

    homeController.productListFiltered.value = filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName, // Keep category name from API
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSortBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _initializeProducts,
              child: isLoading
                  ? _buildLoadingGrid()
                  : Obx(() => _buildProductGrid()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSortOption,
          icon: const Icon(Icons.sort),
          isExpanded: true,
          hint: Text(tr('sort_by')),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedSortOption = newValue;
                _applyFilters();
              });
            }
          },
          items: sortOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                tr(value),
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[300]!,
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[600]!
          : Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = homeController.productListFiltered;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 48,
                color: Theme.of(context).disabledColor),
            const SizedBox(height: 16),
            Text(
              tr('no_products_found'),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: products.length,
      itemBuilder: (_, index) => _buildProductCard(products[index]),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.PRODUCT_DETAILS,
          arguments: product,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'product-${product.id}',
                child: _buildProductImage(product),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildProductInfo(product),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: product.images?.isNotEmpty == true
          ? Image.network(
        product.images![0]!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.error_outline, size: 24),
        ),
      )
          : const Center(
        child: Icon(Icons.image, size: 24),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title ?? tr('unknown_product'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          tr('price_value', args: [product.price?.toStringAsFixed(2) ?? '0.00']),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(tr('price_range')),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RangeSlider(
                    min: 0,
                    max: 1000,
                    divisions: 50,
                    values: priceRange,
                    labels: RangeLabels(
                      tr('price_value', args: [priceRange.start.toStringAsFixed(0)]),
                      tr('price_value', args: [priceRange.end.toStringAsFixed(0)]),
                    ),
                    onChanged: (values) => setState(() => priceRange = values),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tr('price_value', args: [priceRange.start.toInt().toString()])),
                      Text(tr('price_value', args: [priceRange.end.toInt().toString()])),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    priceRange = const RangeValues(0, 1000);
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: Text(tr('reset')),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: Text(tr('apply')),
                ),
              ],
            );
          },
        );
      },
    );
  }
}