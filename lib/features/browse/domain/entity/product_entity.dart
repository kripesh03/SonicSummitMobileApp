import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String title;
  final String artistName;
  final String description;
  final double oldPrice;
  final double newPrice;
  final String category;
  final bool trending;

  const ProductEntity({
    this.id,
    required this.title,
    required this.artistName,
    required this.description,
    required this.oldPrice,
    required this.newPrice,
    required this.category,
    this.trending = false,
  });

  const ProductEntity.empty()
      : id = "_empty.productID",
        title = '',
        artistName = '',
        description = '',
        oldPrice = 0.0,
        newPrice = 0.0,
        category = '',
        trending = false;

  @override
  List<Object?> get props => [
        id,
        title,
        artistName,
        description,
        oldPrice,
        newPrice,
        category,
        trending,
      ];
}
