import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/dto/delete_cart_dto.dart';

void main() {
  group('DeleteCartDTO Tests', () {
    final json = {
      'userId': 'user123',
      'productId': 'product123',
    };

    test('should correctly deserialize from JSON', () {
      final deleteCartDTO = DeleteCartDTO.fromJson(json);

      expect(deleteCartDTO.userId, 'user123');
      expect(deleteCartDTO.productId, 'product123');
    });

    test('should correctly serialize to JSON', () {
      final deleteCartDTO = DeleteCartDTO(userId: 'user123', productId: 'product123');
      final serializedJson = deleteCartDTO.toJson();

      expect(serializedJson['userId'], 'user123');
      expect(serializedJson['productId'], 'product123');
    });
  });
}
