import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';

class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String artistName;
  final String description;
  final double oldPrice;
  final double newPrice;
  final String category;
  final bool trending;
  final String? productImage;  // Added the productImage field

  const ProductApiModel({
    this.id,
    required this.title,
    required this.artistName,
    required this.description,
    required this.oldPrice,
    required this.newPrice,
    required this.category,
    this.trending = false,
    this.productImage,  // Added productImage to the constructor
  });

  const ProductApiModel.empty()
      : id = '',
        title = '',
        artistName = '',
        description = '',
        oldPrice = 0.0,
        newPrice = 0.0,
        category = '',
        trending = false,
        productImage = null;  // Default value for productImage

  // From Json
  factory ProductApiModel.fromJson(Map<String, dynamic> json) {
    return ProductApiModel(
      id: json['_id'],
      title: json['title'],
      artistName: json['artistName'],
      description: json['description'] ?? '',
      oldPrice: _parseDecimal(json['old_price']),
      newPrice: _parseDecimal(json['new_price']),
      category: json['category'],
      trending: json['trending'] ?? false,
      productImage: json['productImage'],  // Handle productImage field from JSON
    );
  }

  // Static helper function to parse the decimal values
  static double _parseDecimal(dynamic value) {
    if (value is Map && value.containsKey('\$numberDecimal')) {
      // If it's a map, extract the decimal string and parse it as double
      return double.tryParse(value['\$numberDecimal'].toString()) ?? 0.0;
    }
    return 0.0; // Fallback if the value is not in the expected format
  }

  // To Json
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'artistName': artistName,
      'description': description,
      'old_price': {'\$numberDecimal': oldPrice},
      'new_price': {'\$numberDecimal': newPrice},
      'category': category,
      'trending': trending,
      'productImage': productImage,  // Include productImage in the JSON
    };
  }

  // Convert API Object to Entity
  ProductEntity toEntity() => ProductEntity(
        id: id,
        title: title,
        artistName: artistName,
        description: description,
        oldPrice: oldPrice,
        newPrice: newPrice,
        category: category,
        trending: trending,
        productImage: productImage,  // Include productImage in the entity
      );

  // Convert API List to Entity List
  static List<ProductEntity> toEntityList(List<ProductApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

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
        productImage,  // Include productImage in comparison
      ];
}
