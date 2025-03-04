import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final String orderId;
  final String userId;
  final String? email; // Make email nullable
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderEntity({
    required this.orderId,
    required this.userId,
    this.email, // Nullable email
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [orderId, userId, email, items, totalAmount, status, createdAt, updatedAt];
}
