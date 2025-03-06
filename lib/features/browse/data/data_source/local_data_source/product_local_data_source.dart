import 'package:sonic_summit_mobile_app/core/network/hive_service.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_hive_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';

class ProductLocalDataSource {
  final HiveService hiveService;

  ProductLocalDataSource({required this.hiveService});

  // Method to save product
  Future<void> saveProduct(ProductEntity product) async {
    try {
      // Convert ProductEntity to ProductHiveModel
      final productHiveModel = ProductHiveModel.fromEntity(product);

      // Save product to Hive using HiveService
      await hiveService.saveProduct(productHiveModel);
    } catch (e) {
      throw Exception('Error saving product: $e');
    }
  }

  // Method to get a product by ID from Hive
  Future<ProductEntity?> getProductById(String productId) async {
    try {
      // Fetch product from Hive
      final productHiveModel = await hiveService.getProductById(productId);

      if (productHiveModel != null) {
        return productHiveModel.toEntity(); // Convert Hive model back to entity
      } else {
        return null; // Return null if no product found in Hive
      }
    } catch (e) {
      throw Exception('Error retrieving product: $e');
    }
  }

  // Method to get all products from Hive
  Future<List<ProductEntity>> getAllProducts() async {
    try {
      // Fetch all products from Hive
      final allProductHiveModels = await hiveService.getAllProducts();
      
      // Convert Hive models to entity list
      return allProductHiveModels.map((product) => product.toEntity()).toList();
    } catch (e) {
      throw Exception('Error retrieving products: $e');
    }
  }
}
