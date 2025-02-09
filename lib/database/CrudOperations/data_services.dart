import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/product_model.dart';

class ProductDatabaseHelper {
  static const String productBox = 'products';
  static late Box<Product> _productBox;
  static final ValueNotifier<List<Product>> productsNotifier =
      ValueNotifier([]);

  /// Initialize Hive Boxes
  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(productBox)) {
        _productBox = await Hive.openBox<Product>(productBox);
      } else {
        _productBox = Hive.box<Product>(productBox);
      }
      await getAllProducts();
    } catch (e) {
      log('Error initializing boxes: $e');
    }
  }

  /// Check if Boxes are Open
  static bool get isInitialized => Hive.isBoxOpen(productBox);

  /// Add Product
  static Future<void> addProduct(Product product) async {
    if (!isInitialized) await init();

    try {
      await _productBox.put(product.id, product);
      await getAllProducts();
    } catch (e) {
      log('Error adding product: $e');
    }
  }

  /// Get All Products
  static Future<void> getAllProducts() async {
    if (!isInitialized) await init();
    try {
      productsNotifier.value = _productBox.values.toList();
      productsNotifier.notifyListeners();
    } catch (e) {
      log('Error fetching products: $e');
    }
  }

  /// Update Product
  static Future<void> updateProduct(
      String productId, Product updatedProduct) async {
    if (!isInitialized) await init();
    try {
      await _productBox.put(productId, updatedProduct);
      await getAllProducts();
    } catch (e) {
      log('Error updating product: $e');
    }
  }

  /// Delete Product
  static Future<void> deleteProduct(String productId) async {
    if (!isInitialized) await init();
    try {
      await _productBox.delete(productId);
      await getAllProducts();
    } catch (e) {
      log('Error deleting product: $e');
    }
  }
}
