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
  final String? productImage;  // Added the productImage field

  const ProductEntity({
    this.id,
    required this.title,
    required this.artistName,
    required this.description,
    required this.oldPrice,
    required this.newPrice,
    required this.category,
    this.trending = false,
    this.productImage,  // Added the productImage parameter in the constructor
  });

  const ProductEntity.empty()
      : id = "_empty.productID",
        title = '',
        artistName = '',
        description = '',
        oldPrice = 0.0,
        newPrice = 0.0,
        category = '',
        trending = false,
        productImage = null;  // Default value for productImage

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
        productImage,  // Include productImage in the comparison
      ];
}
