import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/dto/get_cart_dto.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/model/cart_api_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';

void main() {
  group('GetCartDTO Tests', () {
    final json = {
      'items': [
        {
          '_id': 'cart123',
          'productId': {
            '_id': 'product123',
            'title': 'Product 1',
            'artistName': 'Artist 1',
            'description': 'Description of Product 1',
            'old_price': {'\$numberDecimal': 100.0},
            'new_price': {'\$numberDecimal': 80.0},
            'category': 'Category 1',
            'productImage': 'https://example.com/product1.jpg',
          },
          'itemId': 'item123',
          'totalPrice': 80.0,
        },
      ],
    };

    test('should correctly deserialize from JSON', () {
      final getCartDTO = GetCartDTO.fromJson(json);

      expect(getCartDTO.data.length, 1);
      expect(getCartDTO.data[0].id, 'cart123');
      expect(getCartDTO.data[0].product.id, 'product123');
      expect(getCartDTO.data[0].product.title, 'Product 1');
      expect(getCartDTO.data[0].product.artistName, 'Artist 1');
      expect(getCartDTO.data[0].totalPrice, 80.0);
    });

  });
}
