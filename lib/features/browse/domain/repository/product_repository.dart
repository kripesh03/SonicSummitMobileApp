import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';

abstract interface class IProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
}
