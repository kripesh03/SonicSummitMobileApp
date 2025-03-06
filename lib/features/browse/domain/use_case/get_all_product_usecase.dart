import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/app/usecase/usecase.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/data_source/local_data_source/product_local_data_source.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/repository/product_repository.dart';

class GetAllProductUseCase
    implements UsecaseWithoutParams<List<ProductEntity>> {
  final IProductRepository productRepository;
  final ProductLocalDataSource productLocalDataSource; // Add local data source

  GetAllProductUseCase({
    required this.productRepository,
    required this.productLocalDataSource,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> call() {
    return productRepository.getProducts();
  }

  // Method to get products from local storage (Hive)
  Future<List<ProductEntity>> getProductsFromLocal() async {
    try {
      final localProducts = await productLocalDataSource.getAllProducts();
      return localProducts;
    } catch (e) {
      throw Exception('Error fetching products from local storage: $e');
    }
  }
}
