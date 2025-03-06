class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  // static const String baseUrl = "http://10.0.2.2:3000/api/";

  static const String baseUrl = "http://192.168.1.5:3000/api/";

  // ====================== Auth Routes ======================
  static const String login = "auth/login";
  static const String register = "auth/register";

  static const String imageUrl = "http://192.168.1.5:3000/uploads/";
  // static const String imageUrl = "http://10.0.2.2:3000/uploads/";
  static const String uploadImage = "auth/uploadImage";

  static const String getAllProducts = "product";
  // static const String productimageUrl = "http://10.0.2.2:3000";
  static const String productimageUrl = "http://192.168.1.5:3000";
  
  static String getProduct(String productId) {
    return "product/$productId"; // Endpoint to fetch product details by ID
  }

  static String getCart(String userId) {
    return "cart/$userId"; // Append userId to the cart endpoint
  }

  static const String addToCart = "cart/add";
  static const String removeFromCart = "cart/remove";

  // ====================== Order Routes ======================
  static const String createOrder = "orders"; // Endpoint for creating an order

  // Add this new endpoint to fetch orders by user ID
  static String getOrdersByUserId(String userId) {
    return "orders/user/$userId"; // Endpoint to fetch orders by user ID
  }

  // ====================== User Routes ======================
  static String getUser(String userId) {
    return "auth/user/$userId"; // Endpoint to fetch user details by ID
  }
}