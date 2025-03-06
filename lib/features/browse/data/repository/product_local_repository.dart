import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/data_source/local_data_source/product_local_data_source.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/repository/product_repository.dart';

class ProductLocalRepository implements IProductRepository {
  final ProductLocalDataSource localDataSource;

  ProductLocalRepository({required this.localDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await localDataSource.getAllProducts();
      return Right(products);
    } catch (e) {
      return Left(
        LocalDatabaseFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String productId) async {
    try {
      final product = await localDataSource.getProductById(productId);
      if (product != null) {
        return Right(product);
      } else {
        return Left(
          LocalDatabaseFailure(
            message: "Product not found",
          ),
        );
      }
    } catch (e) {
      return Left(
        LocalDatabaseFailure(
          message: e.toString(),
        ),
      );
    }
  }
}

