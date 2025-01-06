import 'dart:convert';

import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/service_exception.dart';
import '../screens/home/models/category.dart';
import '../utils/logger.dart';

class CategoryRepository {
  static Future getCategories() async {
    try {
      Response response =
      await ApiClient.getRequest(endpoint: ApiEndPoints.getCategories);
      if (response.statusCode == 200) {
        logger.d("Response : ${response.data}");
        var json = jsonEncode(response.data);
        return categoryListFromJson(json);
      } else {
        logger.d("Response is null : ${response.data}");
      }
    } on ServiceException catch (e) {
      throw RepoServiceException(message: e.message);
    }
  }
}