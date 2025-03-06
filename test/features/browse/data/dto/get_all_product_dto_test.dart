import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/dto/get_all_product_dto.dart';

void main() {
  group('GetAllProductDTO Tests', () {
    // Sample JSON data for the test
    final List<dynamic> json = [
      {
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
      {
        '_id': '124',
        'title': 'Product 2',
        'artistName': 'Artist 2',
        'description': 'Description of Product 2',
        'old_price': {'\$numberDecimal': 150.0},
        'new_price': {'\$numberDecimal': 120.0},
        'category': 'Category 2',
        'trending': false,
        'productImage': 'https://example.com/product2.jpg',
      }
    ];

    test('should correctly deserialize from JSON', () {
      final getAllProductDTO = GetAllProductDTO.fromJson(json);

      // Validate that the GetAllProductDTO object is correctly deserialized
      expect(getAllProductDTO.data.length, 2);
      expect(getAllProductDTO.data[0].id, '123');
      expect(getAllProductDTO.data[0].title, 'Product 1');
      expect(getAllProductDTO.data[0].artistName, 'Artist 1');
      expect(getAllProductDTO.data[0].description, 'Description of Product 1');
      expect(getAllProductDTO.data[0].oldPrice, 100.0);
      expect(getAllProductDTO.data[0].newPrice, 80.0);
      expect(getAllProductDTO.data[0].category, 'Category 1');
      expect(getAllProductDTO.data[0].trending, true);
      expect(getAllProductDTO.data[0].productImage, 'https://example.com/product1.jpg');
    });

    test('should correctly serialize to JSON', () {
      final products = [
        ProductApiModel(
          id: '123',
          title: 'Product 1',
          artistName: 'Artist 1',
          description: 'Description of Product 1',
          oldPrice: 100.0,
          newPrice: 80.0,
          category: 'Category 1',
          trending: true,
          productImage: 'https://example.com/product1.jpg',
        ),
        ProductApiModel(
          id: '124',
          title: 'Product 2',
          artistName: 'Artist 2',
          description: 'Description of Product 2',
          oldPrice: 150.0,
          newPrice: 120.0,
          category: 'Category 2',
          trending: false,
          productImage: 'https://example.com/product2.jpg',
        ),
      ];

      final getAllProductDTO = GetAllProductDTO(data: products);
      final serializedJson = getAllProductDTO.toJson();

      // Validate that the serialized JSON matches the expected format
      expect(serializedJson['data'][0]['_id'], '123');
      expect(serializedJson['data'][0]['title'], 'Product 1');
      expect(serializedJson['data'][0]['artistName'], 'Artist 1');
      expect(serializedJson['data'][0]['description'], 'Description of Product 1');
      expect(serializedJson['data'][0]['old_price']['\$numberDecimal'], 100.0);
      expect(serializedJson['data'][0]['new_price']['\$numberDecimal'], 80.0);
      expect(serializedJson['data'][0]['category'], 'Category 1');
      expect(serializedJson['data'][0]['trending'], true);
      expect(serializedJson['data'][0]['productImage'], 'https://example.com/product1.jpg');
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
