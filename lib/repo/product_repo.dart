import 'dart:convert';

import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/service_exception.dart';
import '../screens/home/models/product.dart';
import '../utils/logger.dart';

class ProductRepository {
  static Future getProducts() async {
    try {
      Response response =
          await ApiClient.getRequest(endpoint: ApiEndPoints.getProducts);
      if (response.statusCode == 200) {
        logger.d("Response : ${response.data}");
        var json = jsonEncode(response.data);
        return productListFromJson(json);
      } else {
        logger.d("Response is null : ${response.data}");
      }
    } on ServiceException catch (e) {
      throw RepoServiceException(message: e.message);
    }
  }

  static Future getProductsByCategory(String categoryId) async {
    try {
      print("Category" + categoryId);
      print(ApiEndPoints.productsByCategories + categoryId);
      Response response =
      await ApiClient.getRequest(endpoint: ApiEndPoints.productsByCategories + categoryId);
      if (response.statusCode == 200) {
        logger.d("Response : ${response.data}");
        var json = jsonEncode(response.data);
        return productListFromJson(json);
      } else {
        logger.d("Response is null : ${response.data}");
      }
    } on ServiceException catch (e) {
      throw RepoServiceException(message: e.message);
    }
  }
}
