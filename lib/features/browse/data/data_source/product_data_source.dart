import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';

abstract interface class IProductDataSource {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity> getProductById(String productId);
}
