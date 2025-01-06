class ApiEndPoints {
  ApiEndPoints._();
  static String getProducts = '${baseUrl}products';
  static String getCategories= '${baseUrl}categories';
  static String baseUrl = 'https://api.escuelajs.co/api/v1/';
  static String productsByCategories = "$getProducts/?categoryId=";
}
