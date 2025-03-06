import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/dto/add_cart_dto.dart';

void main() {
  group('AddCartDTO Tests', () {
    final json = {
      'userId': 'user123',
      'productId': 'product123',
    };

    test('should correctly deserialize from JSON', () {
      final addCartDTO = AddCartDTO.fromJson(json);

      expect(addCartDTO.userId, 'user123');
      expect(addCartDTO.productId, 'product123');
    });

    test('should correctly serialize to JSON', () {
      final addCartDTO = AddCartDTO(userId: 'user123', productId: 'product123');
      final serializedJson = addCartDTO.toJson();

      expect(serializedJson['userId'], 'user123');
      expect(serializedJson['productId'], 'product123');
    });
  });
}
