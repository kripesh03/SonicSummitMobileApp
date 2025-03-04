import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String title;
  final double newPrice;
  final String itemId;  // Change to nullable String?

  CartItemEntity({
    required this.title,
    required this.newPrice,
    required this.itemId,  // itemId is now optional
  });

  @override
  List<Object?> get props => [title, newPrice, itemId];
}
