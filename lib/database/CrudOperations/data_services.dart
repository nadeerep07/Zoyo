import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/product_model.dart';

const String productBox = 'products';
final ValueNotifier<List<Product>> productsNotifier = ValueNotifier([]);

Future<void> addProduct(Product product) async {
  var box = Hive.box<Product>(productBox);
  await box.put(product.id, product);
  getAllProducts();
  productsNotifier.notifyListeners();
}

Future<void> updateProduct(String productId, Product updatedProduct) async {
  var box = Hive.box<Product>(productBox);
  await box.put(productId, updatedProduct);
  getAllProducts();
  productsNotifier.notifyListeners();
}

Future<void> getAllProducts() async {
  var box = Hive.box<Product>(productBox);
  productsNotifier.value = box.values.toList();
  productsNotifier.notifyListeners();
}

Future<void> deleteProduct(String productId) async {
  var box = Hive.box<Product>(productBox);
  await box.delete(productId);
  getAllProducts();
  productsNotifier.notifyListeners();
}
