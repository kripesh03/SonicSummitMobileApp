class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:3000/api/";

  // ====================== Auth Routes ======================
  static const String login = "auth/login";
  static const String register = "auth/register";

  static const String imageUrl = "http://10.0.2.2:3000/uploads/";
  static const String uploadImage = "auth/uploadImage";

  static const String getAllProducts = "product";

  static String getCart(String userId) {
    return "cart/$userId"; // Append userId to the cart endpoint
  }

  static const String addToCart = "cart/add";
  static const String removeFromCart = "cart/remove";

  // ====================== Order Routes ======================
  static String createOrder = "orders"; // Endpoint for creating an order
}
