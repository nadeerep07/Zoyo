import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';

class DatabaseHelper {
  static const String productBox = 'products';
  static const String categoryBox = 'categories';

  static final ValueNotifier<List<Product>> productsNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<Category>> categoriesNotifier =
      ValueNotifier([]);

  static Future<void> openBoxes() async {
    if (!Hive.isBoxOpen(productBox)) {
      await Hive.openBox<Product>(productBox);
    }
    if (!Hive.isBoxOpen(categoryBox)) {
      await Hive.openBox<Category>(categoryBox);
    }
    productsNotifier.value = Hive.box<Product>(productBox).values.toList();
    categoriesNotifier.value = Hive.box<Category>(categoryBox).values.toList();
  }

  static Future<void> addProduct(Product product) async {
    var box = Hive.box<Product>(productBox);
    await box.put(product.id, product);
    getAllProducts();
    productsNotifier.notifyListeners();
  }

  static Future<void> updateProduct(
      String productId, Product updatedProduct) async {
    var box = Hive.box<Product>(productBox);
    await box.put(productId, updatedProduct);
    getAllProducts();
    productsNotifier.notifyListeners();
  }

  static Future<void> getAllProducts() async {
    var box = Hive.box<Product>(productBox);
    productsNotifier.value = box.values.toList();
    productsNotifier.notifyListeners();
  }

  static Future<void> deleteProduct(String productId) async {
    var box = Hive.box<Product>(productBox);
    await box.delete(productId);
    getAllProducts();
    productsNotifier.notifyListeners();
  }

/**
 * * Categroy CRUD Operations
 */
  static Future<void> addCategory(Category category) async {
    var box = Hive.box<Category>(categoryBox);
    await box.put(category.id, category);
    categoriesNotifier.value = box.values.toList();
    categoriesNotifier.notifyListeners();
  }

  static Future<void> updateCategory(
      String categoryId, Category updatedCategory) async {
    var box = Hive.box<Category>(categoryBox);
    await box.put(categoryId, updatedCategory);
    categoriesNotifier.value = box.values.toList();
    categoriesNotifier.notifyListeners();
  }

  static Future<void> getAllCategories() async {
    var box = Hive.box<Category>(categoryBox);
    categoriesNotifier.value = box.values.toList();
    categoriesNotifier.notifyListeners();
  }

  static Future<void> deleteCategory(String categoryId) async {
    var box = Hive.box<Category>(categoryBox);
    await box.delete(categoryId);
    categoriesNotifier.value = box.values.toList();
    categoriesNotifier.notifyListeners();
  }
}
