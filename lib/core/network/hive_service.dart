import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonic_summit_mobile_app/app/constants/hive_table_constant.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/model/auth_hive_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_hive_model.dart';

class HiveService {
  static Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}sonic_summit.db';
    Hive.init(path);

    Hive.registerAdapter(AuthHiveModelAdapter());
  }




  // Auth Queries
  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Login using username and password
  Future<AuthHiveModel?> login(String username, String password) async {
    // var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.studentBox);
    // var auth = box.values.firstWhere(
    //     (element) =>
    //         element.username == username && element.password == password,
    //     orElse: () => AuthHiveModel.initial());
    // return auth;

    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var student = box.values.firstWhere((element) =>
        element.username == username && element.password == password);
    box.close();
    return student;
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Clear Student Box
  Future<void> clearStudentBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  

  Future<void> saveProduct(ProductHiveModel product) async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
    await box.put(product.id, product);  // Store Product using the product id
  }

  Future<ProductHiveModel?> getProductById(String productId) async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
    return box.get(productId);  // Retrieve Product by ID
  }

  Future<List<ProductHiveModel>> getAllProducts() async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
    return box.values.toList();  // Get all stored products
  }

  Future<void> deleteProduct(String productId) async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
    await box.delete(productId);  // Delete Product by ID
  }

  Future<void> clearAllProducts() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.productBox);  // Clear all products from the box
  }

  Future<void> close() async {
    await Hive.close();
  }


}
