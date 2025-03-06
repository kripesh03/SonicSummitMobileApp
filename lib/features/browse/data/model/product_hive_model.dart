import 'package:hive/hive.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
part 'product_hive_model.g.dart';


@HiveType(typeId: 1)
class ProductHiveModel {
  @HiveField(0)
  final String? id;  // Make this nullable

  @HiveField(1)
  final String title;
  @HiveField(2)
  final String artistName;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final double oldPrice;
  @HiveField(5)
  final double newPrice;
  @HiveField(6)
  final String category;
  @HiveField(7)
  final bool trending;

  ProductHiveModel({
    this.id,  // Allow id to be nullable
    required this.title,
    required this.artistName,
    required this.description,
    required this.oldPrice,
    required this.newPrice,
    required this.category,
    required this.trending,
  });

  // Convert entity to Hive model
  factory ProductHiveModel.fromEntity(ProductEntity entity) {
    return ProductHiveModel(
      id: entity.id,  // Allow null id
      title: entity.title,
      artistName: entity.artistName,
      description: entity.description,
      oldPrice: entity.oldPrice,
      newPrice: entity.newPrice,
      category: entity.category,
      trending: entity.trending,
    );
  }

  // Convert Hive model to entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,  // Allow null id
      title: title,
      artistName: artistName,
      description: description,
      oldPrice: oldPrice,
      newPrice: newPrice,
      category: category,
      trending: trending,
    );
  }
}
