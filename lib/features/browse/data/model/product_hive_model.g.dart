// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductHiveModelAdapter extends TypeAdapter<ProductHiveModel> {
  @override
  final int typeId = 1;

  @override
  ProductHiveModel read(BinaryReader reader) {
    return ProductHiveModel(
      id: reader.readString(),  // Read the id field (nullable)
      title: reader.readString(),
      artistName: reader.readString(),
      description: reader.readString(),
      oldPrice: reader.readDouble(),
      newPrice: reader.readDouble(),
      category: reader.readString(),
      trending: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductHiveModel obj) {
    writer.writeString(obj.id ?? '');  // Handle nullable id
    writer.writeString(obj.title);
    writer.writeString(obj.artistName);
    writer.writeString(obj.description);
    writer.writeDouble(obj.oldPrice);
    writer.writeDouble(obj.newPrice);
    writer.writeString(obj.category);
    writer.writeBool(obj.trending);
  }
}
