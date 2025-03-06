import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/order/data/model/order_api_model.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_item_entity.dart';

void main() {
  group('OrderApiModel Tests', () {
    final Map<String, dynamic> json = {
      'id': '123',
      'userId': 'user123',
      'name': 'John Doe',
      'email': 'johndoe@example.com',
      'phone': '1234567890',
      'productIds': [
        {'id': 'product1', 'quantity': 2},
        {'id': 'product2', 'quantity': 1},
      ],
      'totalPrice': 100.0,
      'createdAt': '2025-03-01T12:00:00Z',
      'updatedAt': '2025-03-01T12:00:00Z',
    };

    test('should correctly deserialize from JSON', () {
      final orderApiModel = OrderApiModel.fromJson(json);

      // Validate the deserialized object
      expect(orderApiModel.id, '123');
      expect(orderApiModel.userId, 'user123');
      expect(orderApiModel.name, 'John Doe');
      expect(orderApiModel.email, 'johndoe@example.com');
      expect(orderApiModel.phone, '1234567890');
      expect(orderApiModel.productIds.length, 2);
      expect(orderApiModel.totalPrice, 100.0);
      expect(orderApiModel.createdAt, DateTime.parse('2025-03-01T12:00:00Z'));
      expect(orderApiModel.updatedAt, DateTime.parse('2025-03-01T12:00:00Z'));
    });

    test('should correctly serialize to JSON', () {
      final orderApiModel = OrderApiModel.fromJson(json);
      final serializedJson = orderApiModel.toJson();

      // Validate the serialized JSON
      expect(serializedJson['id'], '123');
      expect(serializedJson['userId'], 'user123');
      expect(serializedJson['name'], 'John Doe');
      expect(serializedJson['email'], 'johndoe@example.com');
      expect(serializedJson['phone'], '1234567890');
      expect(serializedJson['productIds'].length, 2);
      expect(serializedJson['totalPrice'], 100.0);
      expect(serializedJson['createdAt'], '2025-03-01T12:00:00Z');
      expect(serializedJson['updatedAt'], '2025-03-01T12:00:00Z');
    });

    test('should correctly convert to OrderEntity', () {
      final orderApiModel = OrderApiModel.fromJson(json);
      final orderEntity = orderApiModel.toEntity();

      // Validate the converted OrderEntity
      expect(orderEntity.orderId, '123');
      expect(orderEntity.userId, 'user123');
      expect(orderEntity.email, 'johndoe@example.com');
      expect(orderEntity.items.length, 2);
      expect(orderEntity.totalAmount, 100.0);
      expect(orderEntity.status, 'pending');
      expect(orderEntity.createdAt, DateTime.parse('2025-03-01T12:00:00Z'));
      expect(orderEntity.updatedAt, DateTime.parse('2025-03-01T12:00:00Z'));

      // Check if OrderItemEntity conversion works
      expect(orderEntity.items[0].productId, 'product1');
      expect(orderEntity.items[0].quantity, 2);
    });

    test('should correctly convert a list of OrderApiModels to a list of OrderEntities', () {
      final orderApiModels = [
        OrderApiModel.fromJson(json),
        OrderApiModel.fromJson(json),
      ];
      final orderEntities = OrderApiModel.toEntityList(orderApiModels);

      // Validate the list conversion
      expect(orderEntities.length, 2);
      expect(orderEntities[0].orderId, '123');
      expect(orderEntities[1].orderId, '123');
      expect(orderEntities[0].items.length, 2);
      expect(orderEntities[1].items.length, 2);
    });
  });
}
