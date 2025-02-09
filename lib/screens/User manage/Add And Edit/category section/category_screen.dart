import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/CrudOperations/category_db.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/screens/User%20manage/Add%20And%20Edit/category%20section/category_dialog.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';

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
    CategoryDatabaseHelper.getAllCategories();
  }

  void openHiveBox() async {
    categoryBox = await Hive.box<Category>(CategoryDatabaseHelper.categoryBox);
  }

  void showCategoryDialog({Category? category, int? index}) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(category: category, index: index),
    );
  }

  @override
  Widget build(BuildContext context) {
    CategoryDatabaseHelper.getAllCategories;
    return Scaffold(
      appBar:
          AppBar(leading: backButton(context), title: const Text("Categories")),
      body: ValueListenableBuilder<List<Category>>(
        valueListenable: CategoryDatabaseHelper.categoriesNotifier,
        builder: (context, categories, _) {
          if (categories.isEmpty) {
            return const Center(child: Text("No categories added"));
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                leading:
                    Image.file(File(category.imagePath), width: 50, height: 50),
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
                          CategoryDatabaseHelper.deleteCategory(category.id),
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
