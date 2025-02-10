import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/category_model.dart';

const String categoryBox = 'categoryBox';

final ValueNotifier<List<Category>> categoriesNotifier = ValueNotifier([]);

/// Add Category
Future<void> addCategory(Category category) async {
  var box = await Hive.openBox<Category>(categoryBox); // Ensure box is open
  await box.put(category.id, category);
  getAllCategories();
  categoriesNotifier.notifyListeners();
}

/// Get All Categories
Future<void> getAllCategories() async {
  var box = await Hive.openBox<Category>(categoryBox);
  categoriesNotifier.value = box.values.toList();
  categoriesNotifier.notifyListeners();
}

/// Update Category
Future<void> updateCategory(String categoryId, Category updatedCategory) async {
  var box = await Hive.openBox<Category>(categoryBox);
  await box.put(categoryId, updatedCategory);
  getAllCategories();
  categoriesNotifier.notifyListeners();
}

/// Delete Category
Future<void> deleteCategory(String categoryId) async {
  var box = await Hive.openBox<Category>(categoryBox);
  await box.delete(categoryId);
  getAllCategories();
  categoriesNotifier.notifyListeners();
}
