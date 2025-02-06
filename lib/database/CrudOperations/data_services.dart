import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/product_model.dart';

class ProductDB {
  static const String _boxName = 'productBox';

  /// Open the Hive box
  static Future<Box<Product>> _openBox() async {
    return await Hive.openBox<Product>(_boxName);
  }

  Future<void> addProduct(Product newProduct) async {
    var box = await Hive.openBox<Product>('products');
    await box.add(newProduct);
    // The UI will automatically reflect changes via ValueListenableBuilder
  }

  /// Read all products
  static Future<List<Product>> getAllProducts() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Read a single product by ID
  static Future<Product?> getProductById(String code) async {
    final box = await _openBox();
    return box.get(code);
  }

  /// Update a product
  Future<void> updateProduct(String key, Product updatedProduct) async {
    final box = await Hive.openBox<Product>('products');
    await box.put(key, updatedProduct);
  }

  /// Delete product
  Future<void> deleteProduct(int index) async {
    final box = await Hive.openBox<Product>('products');
    await box.deleteAt(index);
    // UI will automatically reflect changes via ValueListenableBuilder
  }

  /// Delete all products
  static Future<void> deleteAllProducts() async {
    final box = await _openBox();
    await box.clear();
  }
}
