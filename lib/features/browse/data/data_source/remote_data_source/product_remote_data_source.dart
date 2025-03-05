import 'package:dio/dio.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/dto/get_all_product_dto.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';

class ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSource({
    required Dio dio,
  }) : _dio = dio;

  Future<List<ProductEntity>> getProducts() async {
    try {
      var response = await _dio.get(ApiEndpoints.getAllProducts);
      if (response.statusCode == 200) {
        // Parse the response data as a List<dynamic>
        List<dynamic> responseData = response.data;
        GetAllProductDTO productDTO = GetAllProductDTO.fromJson(responseData);
        return ProductApiModel.toEntityList(productDTO.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ProductEntity> getProductById(String productId) async {
    try {
      var response = await _dio.get(ApiEndpoints.getProduct(productId));
      if (response.statusCode == 200) {
        return ProductApiModel.fromJson(response.data).toEntity();
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
