import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/Category%20Section/show_dialog_category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Box<Category> categoryBox;

  @override
  void initState() {
    super.initState();
    openHiveBox();
    DatabaseHelper.getAllCategories();
  }

  void openHiveBox() {
    categoryBox = Hive.box<Category>(DatabaseHelper.categoryBox);
  }

  void showCategoryDialog({Category? category, int? index}) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(category: category, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: ValueListenableBuilder<List<Category>>(
        valueListenable: DatabaseHelper.categoriesNotifier,
        builder: (context, categories, _) {
          if (categories.isEmpty) {
            return const Center(child: Text("No categories added"));
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                leading: (category.imagePath != null &&
                        category.imagePath!.isNotEmpty)
                    ? Image.file(
                        File(category.imagePath ?? 'default_image_path'),
                        width: 50,
                        height: 50)
                    : const Icon(Icons.image, size: 50),
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          showCategoryDialog(category: category, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          DatabaseHelper.deleteCategory(category.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
