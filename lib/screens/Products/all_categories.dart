import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/CrudOperations/category_db.dart';
import 'package:zoyo_bathware/database/category_model.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  void initState() {
    super.initState();
    // Fetch categories when the widget initializes
    CategoryDatabaseHelper.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("All Categories"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<List<Category>>(
          valueListenable: CategoryDatabaseHelper.categoriesNotifier,
          builder: (context, categories, child) {
            if (categories.isEmpty) {
              return const Center(
                child: Text(
                  "No categories found",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 16, // Spacing between columns
                mainAxisSpacing: 16, // Spacing between rows
                childAspectRatio: 1, // Aspect ratio of each card
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(category: category);
              },
            );
          },
        ),
      ),
    );
  }
}

/// Custom widget to display a category card
class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display category image (if available)
            if (category.imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(category.imagePath),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Icon(Icons.category, size: 60, color: Colors.grey),

            const SizedBox(height: 8),

            // Display category name
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
