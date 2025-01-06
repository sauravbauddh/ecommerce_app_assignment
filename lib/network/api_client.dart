import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart' as DioApi;
import 'package:dio/dio.dart';
import '../utils/logger.dart';
import 'api_endpoints.dart';
import 'service_exception.dart';

class ApiClient {
  static late Dio _dio;
  static late Dio _dioQueue;
  static String accessToken = '';

  static dynamic _requestInterceptor(
      RequestOptions request,
      RequestInterceptorHandler handler,
      ) async {
    request.headers['Authorization'] = accessToken;
    return handler.next(request);
  }

  static Future<void> init() async {
    var option = BaseOptions(baseUrl: ApiEndPoints.getProducts);
    _dio = Dio(option);
    _dioQueue = Dio(option);
    // accessToken = '';
    _dio.options.headers['Authorization'] = accessToken;
    _dioQueue.options.headers['Authorization'] = accessToken;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) => _requestInterceptor(request, handler),
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            String? newToken = await refreshToken();
            _dio.options.headers["Authorization"] = newToken;
            _dioQueue.options.headers["Authorization"] = newToken;
            return handler.resolve(await _dio.fetch(e.requestOptions));
                    } else if (e.response?.statusCode == 469) {
            logout();
          }
          return handler.next(e);
        },
        onResponse: (response, handler) {
          return handler.next(response); // continue
        },
      ),
    );

    ///Queue interceptor
    _dioQueue.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (request, handler) => _requestInterceptor(request, handler),
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            String? newToken = await refreshToken();
            _dioQueue.options.headers["Authorization"] = newToken;
            _dio.options.headers["Authorization"] = newToken;
            return handler.resolve(await _dioQueue.fetch(e.requestOptions));
                    } else if (e.response?.statusCode == 469) {
            logout();
          }
          return handler.next(e);
        },
        onResponse: (response, handler) {
          return handler.next(response); // continue
        },
      ),
    );
  }

  static logout() {
  }

  static DateTime? loginClickTime;

  //get request
  static Future<dynamic> getRequest({
    required String endpoint,
    Options? options,
    Map<String, dynamic> query = const {},
  }) async {
    try {
      DioApi.Response response =
      await _dio.get(endpoint, queryParameters: query, options: options);
      return response;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
            jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //post request
  static Future<dynamic> postRequest({
    required endpoint,
    param = const {"": ""},
    Options? options,
  }) async {
    try {
      logger.d("--------------------");
      DioApi.Response response =
      await _dio.post(endpoint, data: param, options: options);
      return response;
    } on DioException catch (e) {
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
            jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //post request
  static Future<dynamic> postRequestQueue({
    required endpoint,
    param = const {"": ""},
    Options? options,
  }) async {
    try {
      logger.d("--------------------");
      DioApi.Response response =
      await _dioQueue.post(endpoint, data: param, options: options);
      return response;
    } on DioException catch (e) {
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.statusCode != null &&
          (e.response?.statusCode ?? 0) >= 500 &&
          (e.response?.statusCode ?? 0) < 600) {
        throw const ServiceException(message: "Something went wrong");
      }
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
            jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //put request
  static Future<dynamic> putRequest(
      {required endpoint,
        param = const {"": ""},
        id,
        Map<String, dynamic> headers = const {}}) async {
    try {
      logger.d("--------------------");
      logger.d("REQUEST TYPE : PUT ");
      logger.d("REQUEST END POINT : $endpoint" + "/" + id.toString());
      logger.d("REQUEST DATA : $param");
      DioApi.Response response;
      if (id == null) {
        response = await _dio.put(endpoint,
            data: param, options: Options(headers: headers));
      } else {
        response = await _dio.put(endpoint + "/" + id.toString(),
            data: param, options: Options(headers: headers));
      }

      return response;
    } on DioException catch (e) {
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
            jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //patch request
  static Future<dynamic> patchRequest(
      {required endpoint, param = const {"": ""}, id}) async {
    try {
      logger.d("--------------------");
      logger.d("REQUEST TYPE : PUT ");
      logger.d("REQUEST END POINT : $endpoint" + "/" + id.toString());
      logger.d("REQUEST DATA : $param");

      DioApi.Response response =
      await _dio.patch(endpoint + "/" + id.toString(), data: param);

      return response;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
            jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  //delete Request
  static Future<dynamic> deleteRequest({required endpoint, id}) async {
    try {
      logger.d("--------------------");
      logger.d("REQUEST TYPE : delete ");
      logger.d("REQUEST END POINT : $endpoint" + "/" + id.toString());
      DioApi.Response response;
      if (id == null) {
        response = await _dio.delete(endpoint);
      } else {
        response = await _dio.delete(endpoint + "/" + id.toString());
      }

      return response;
    } on DioException catch (e) {
      if (e.response?.data["errors"] != null) {
        throw ServiceException(
            message:
            jsonEncode(List.from(e.response?.data["errors"] ?? []).first));
      }
      logger.e("DIO : : ${e.response?.data}");
      if (e.response?.data["message"] != null &&
          e.response?.data["message"] != "") {
        throw ServiceException(message: e.response?.data["message"].toString());
      }
    }
  }

  static refreshToken() {}

}
