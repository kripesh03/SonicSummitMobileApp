import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/app/usecase/usecase.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/repository/product_repository.dart';

class GetAllProductUseCase implements UsecaseWithoutParams<List<ProductEntity>> {
  final IProductRepository productRepository;

  GetAllProductUseCase({required this.productRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call() {
    return productRepository.getProducts();
  }
}


