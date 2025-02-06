import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/image_picker.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Box<Category> categoryBox;
  final ImagePickerHelper imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  Future<void> openHiveBox() async {
    await Hive.openBox<Category>('categories');
    categoryBox = Hive.box<Category>('categories');
    setState(() {});
  }

  void _showCategoryDialog({Category? category, int? index}) {
    final TextEditingController nameController =
        TextEditingController(text: category?.name ?? "");
    String imagePath = category?.imagePath ?? "";

    Future<void> pickImage(bool fromGallery) async {
      File? pickedImage = fromGallery
          ? await imagePickerHelper.pickImageFromGallery()
          : await imagePickerHelper.pickImageFromCamera();

      if (pickedImage != null) {
        setState(() {
          imagePath = pickedImage.path;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? "Add Category" : "Edit Category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Category Name"),
              ),
              SizedBox(height: 10),
              imagePath.isNotEmpty
                  ? Image.file(File(imagePath), width: 100, height: 100)
                  : Container(),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => pickImage(true),
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final newCategory =
                      Category(name: nameController.text, imagePath: imagePath);
                  if (category == null) {
                    categoryBox.add(newCategory);
                  } else {
                    categoryBox.putAt(index!, newCategory);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: ValueListenableBuilder(
        valueListenable: categoryBox.listenable(),
        builder: (context, Box<Category> box, _) {
          if (box.isEmpty) {
            return Center(child: Text("No categories added"));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final category = box.getAt(index);
              return ListTile(
                leading: category!.imagePath.isNotEmpty
                    ? Image.file(File(category.imagePath),
                        width: 50, height: 50)
                    : Icon(Icons.image, size: 50),
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          _showCategoryDialog(category: category, index: index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => categoryBox.deleteAt(index),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
