import 'package:dio/dio.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/dto/get_all_product_dto.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/core/network/hive_service.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_hive_model.dart';

class ProductRemoteDataSource {
  final Dio _dio;
  final HiveService hiveService;

  ProductRemoteDataSource({
    required Dio dio,
    required this.hiveService,
  }) : _dio = dio;

  // Method to get all products and store them in Hive
  Future<List<ProductEntity>> getProducts() async {
    try {
      var response = await _dio.get(ApiEndpoints.getAllProducts);
      if (response.statusCode == 200) {
        // Parse the response data as a List<dynamic>
        List<dynamic> responseData = response.data;
        GetAllProductDTO productDTO = GetAllProductDTO.fromJson(responseData);

        // Convert the DTO data to a list of ProductEntity
        List<ProductEntity> productEntities = ProductApiModel.toEntityList(productDTO.data);

        // Save the products to Hive
        for (var product in productEntities) {
          // Convert ProductEntity to ProductHiveModel
          final productHiveModel = ProductHiveModel.fromEntity(product);
          // Save to Hive using the HiveService
          await hiveService.saveProduct(productHiveModel);
        }

        return productEntities;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Method to get a single product by ID
  Future<ProductEntity> getProductById(String productId) async {
    try {
      var response = await _dio.get(ApiEndpoints.getProduct(productId));
      if (response.statusCode == 200) {
        ProductEntity product = ProductApiModel.fromJson(response.data).toEntity();

        // Optionally, save the product to Hive as well
        final productHiveModel = ProductHiveModel.fromEntity(product);
        await hiveService.saveProduct(productHiveModel);

        return product;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
