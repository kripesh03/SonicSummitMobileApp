import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String title;
  final double newPrice;

  CartItemEntity({
    required this.title,
    required this.newPrice,
  });

  @override
  List<Object?> get props => [title, newPrice];
}
