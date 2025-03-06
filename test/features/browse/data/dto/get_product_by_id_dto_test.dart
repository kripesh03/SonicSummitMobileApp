import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/dto/get_product_by_id_dto.dart';

void main() {
  group('GetProductByIdDTO Tests', () {
    // Sample JSON data for the test
    final Map<String, dynamic> json = {
      'data': {
        '_id': '123',
        'title': 'Product 1',
        'artistName': 'Artist 1',
        'description': 'Description of Product 1',
        'old_price': {'\$numberDecimal': 100.0},
        'new_price': {'\$numberDecimal': 80.0},
        'category': 'Category 1',
        'trending': true,
        'productImage': 'https://example.com/product1.jpg',
      },
    };

    test('should correctly deserialize from JSON', () {
      final getProductByIdDTO = GetProductByIdDTO.fromJson(json);

      // Validate that the GetProductByIdDTO object is correctly deserialized
      expect(getProductByIdDTO.data.id, '123');
      expect(getProductByIdDTO.data.title, 'Product 1');
      expect(getProductByIdDTO.data.artistName, 'Artist 1');
      expect(getProductByIdDTO.data.description, 'Description of Product 1');
      expect(getProductByIdDTO.data.oldPrice, 100.0);
      expect(getProductByIdDTO.data.newPrice, 80.0);
      expect(getProductByIdDTO.data.category, 'Category 1');
      expect(getProductByIdDTO.data.trending, true);
      expect(getProductByIdDTO.data.productImage, 'https://example.com/product1.jpg');
    });

    test('should correctly serialize to JSON', () {
      final productApiModel = ProductApiModel(
        id: '123',
        title: 'Product 1',
        artistName: 'Artist 1',
        description: 'Description of Product 1',
        oldPrice: 100.0,
        newPrice: 80.0,
        category: 'Category 1',
        trending: true,
        productImage: 'https://example.com/product1.jpg',
      );

      final getProductByIdDTO = GetProductByIdDTO(data: productApiModel);
      final serializedJson = getProductByIdDTO.toJson();

      // Validate that the serialized JSON matches the expected format
      expect(serializedJson['data']['_id'], '123');
      expect(serializedJson['data']['title'], 'Product 1');
      expect(serializedJson['data']['artistName'], 'Artist 1');
      expect(serializedJson['data']['description'], 'Description of Product 1');
      expect(serializedJson['data']['old_price']['\$numberDecimal'], 100.0);
      expect(serializedJson['data']['new_price']['\$numberDecimal'], 80.0);
      expect(serializedJson['data']['category'], 'Category 1');
      expect(serializedJson['data']['trending'], true);
      expect(serializedJson['data']['productImage'], 'https://example.com/product1.jpg');
    });

    test('should convert ProductApiModel to ProductEntity correctly', () {
      final productApiModel = ProductApiModel(
        id: '123',
        title: 'Product 1',
        artistName: 'Artist 1',
        description: 'Description of Product 1',
        oldPrice: 100.0,
        newPrice: 80.0,
        category: 'Category 1',
        trending: true,
        productImage: 'https://example.com/product1.jpg',
      );

      final productEntity = productApiModel.toEntity();

      // Validate that the ProductApiModel is correctly converted to ProductEntity
      expect(productEntity.id, '123');
      expect(productEntity.title, 'Product 1');
      expect(productEntity.artistName, 'Artist 1');
      expect(productEntity.description, 'Description of Product 1');
      expect(productEntity.oldPrice, 100.0);
      expect(productEntity.newPrice, 80.0);
      expect(productEntity.category, 'Category 1');
      expect(productEntity.trending, true);
      expect(productEntity.productImage, 'https://example.com/product1.jpg');
    });
  });
}
