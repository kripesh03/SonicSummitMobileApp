import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [productId, productName, quantity, price];

  static OrderItemEntity fromApi(Map<String, dynamic> product) {
    return OrderItemEntity(
      productId: product['_id'],
      productName: product['title'],
      quantity: 1, // Assuming 1 per product, modify as needed
      price: (product['new_price'] as Map<String, dynamic>)['\$numberDecimal']
          as double,
    );
  }
}
