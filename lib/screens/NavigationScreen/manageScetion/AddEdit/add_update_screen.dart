import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/image_picker.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/text_field.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isEditing;
  final Map<String, String>? existingProduct;

  const AddUpdateScreen({
    Key? key,
    this.isEditing = false,
    this.existingProduct,
  }) : super(key: key);

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController purchaseRateController = TextEditingController();
  final TextEditingController salesRateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  List<String> categories = [];
  List<File> selectedImages = [];
  final ImagePickerHelper imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.isEditing) {
      productNameController.text = widget.existingProduct?['product'] ?? '';
      selectedCategory = widget.existingProduct?['category'];
    }
  }

  Future<void> pickImages() async {
    final List<File>? pickedImages =
        await imagePickerHelper.pickMultipleImages();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        selectedImages.addAll(pickedImages);
      });
    }
  }

  void _loadCategories() async {
    if (!Hive.isBoxOpen('categories')) {
      await Hive.openBox<Category>('categories');
    }

    var box = Hive.box<Category>('categories');

    setState(() {
      categories = box.values.map((category) => category.name).toList();
    });
  }

  void _submitForm() {
    if (productNameController.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    if (widget.isEditing) {
      print("Updating Product...");
    } else {
      print("Adding Product...");
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.isEditing ? "Edit Product" : "Add Product",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Image Picker Section**
              Text(
                "Product Images",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  ...selectedImages.map((image) {
                    return Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.remove(image);
                              });
                            },
                            child: Icon(Icons.cancel, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  if (selectedImages.length < 5)
                    IconButton(
                      icon: Icon(Icons.add_a_photo, color: Colors.blue),
                      onPressed: pickImages,
                    ),
                ],
              ),
              SizedBox(height: 16),

              // **Product Details Section**
              Text(
                "Product Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              buildTextField('Product Name', productNameController,
                  icon: Icons.shopping_bag),
              buildTextField('Product Code', productCodeController,
                  icon: Icons.code),
              buildTextField('Size', sizeController, icon: Icons.straighten),
              buildTextField('Type', typeController, icon: Icons.category),
              SizedBox(height: 16),

              // **Category Dropdown**
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                ),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
              SizedBox(height: 16),

              // **Pricing Section**
              Text(
                "Pricing",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              buildTextField('Quantity', quantityController,
                  icon: Icons.format_list_numbered),
              buildTextField(
                'Purchase Rate',
                purchaseRateController,
                prefix: '\₹',
              ),
              buildTextField(
                'Sales Rate',
                salesRateController,
                prefix: '\₹',
              ),
              SizedBox(height: 16),

              // **Description Section**
              Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              buildTextField('Product Description', descriptionController,
                  maxLines: 3, icon: Icons.description),
              SizedBox(height: 20),

              // **Submit Button**
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitForm,
                  icon: Icon(
                    widget.isEditing ? Icons.update : Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    widget.isEditing ? "Update Product" : "Add Product",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
