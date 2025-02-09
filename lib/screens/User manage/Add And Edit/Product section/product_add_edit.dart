import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/database/CrudOperations/category_db.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/utilitis/unique_id.dart';

class ProductAddEdit extends StatefulWidget {
  final bool isEditing;
  final Product? existingProduct;
  const ProductAddEdit({
    super.key,
    required this.isEditing,
    this.existingProduct,
  });

  @override
  State<ProductAddEdit> createState() => _ProductAddEditState();
}

class _ProductAddEditState extends State<ProductAddEdit> {
  List<XFile> selectedImages = [];
  final ImagePicker imagePickerHelper = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _purchaseRateController = TextEditingController();
  final TextEditingController _salesRateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    CategoryDatabaseHelper.getAllCategories();
    if (widget.isEditing && widget.existingProduct != null) {
      // Populate form fields with existing product data
      _productCodeController.text = widget.existingProduct!.productCode;
      _productNameController.text = widget.existingProduct!.productName;
      _sizeController.text = widget.existingProduct!.size;
      _typeController.text = widget.existingProduct!.type;
      _quantityController.text = widget.existingProduct!.quantity.toString();
      _purchaseRateController.text =
          widget.existingProduct!.purchaseRate.toString();
      _salesRateController.text = widget.existingProduct!.salesRate.toString();
      _descriptionController.text = widget.existingProduct!.description;
      _selectedCategory = widget.existingProduct!.category;
      selectedImages = widget.existingProduct!.imagePaths
          .map((path) => XFile(path))
          .toList(); // Convert paths to XFile
    }
  }

  Future<void> pickImage() async {
    List<XFile> pickedImages = await imagePickerHelper.pickMultiImage();
    setState(() {
      selectedImages = pickedImages;
    });
  }

  void _saveOrUpdateProduct() async {
    if (_formKey.currentState!.validate()) {
      if (selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one image')),
        );
        return;
      }

      // Convert XFile to String paths
      List<String> imagePaths =
          selectedImages.map((file) => file.path).toList();
      final uniqueId = generateUniqueId();

      // Create or update the product
      Product product = Product(
        id: widget.isEditing ? widget.existingProduct!.id : uniqueId,
        productCode: _productCodeController.text,
        productName: _productNameController.text,
        size: _sizeController.text,
        type: _typeController.text,
        quantity: int.parse(_quantityController.text),
        purchaseRate: double.parse(_purchaseRateController.text),
        salesRate: double.parse(_salesRateController.text),
        description: _descriptionController.text,
        category: _selectedCategory!,
        imagePaths: imagePaths,
      );

      if (widget.isEditing) {
        // Update existing product
        await updateProduct(product.id!, product);
      } else {
        // Add new product
        await addProduct(product);
      }

      // Show confirmation and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(widget.isEditing ? 'Product updated!' : 'Product added!')),
      );
      // Navigate back after saving/updating
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.isEditing ? "Edit Product" : "Add Product"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Picker
                InkWell(
                  onTap: pickImage,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedImages.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(selectedImages.first.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.add_a_photo,
                            color: AppColors.primaryColor),
                  ),
                ),
                const SizedBox(height: 10),

                if (selectedImages.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(selectedImages[index].path),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),

                // Product Code
                TextFormField(
                  controller: _productCodeController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.code, color: Colors.grey),
                    labelText: 'Product Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Product Name
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.shopping_bag, color: Colors.grey),
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Size
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product size';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Type
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.type_specimen, color: Colors.grey),
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category Dropdown
                ValueListenableBuilder<List<Category>>(
                  valueListenable: CategoryDatabaseHelper.categoriesNotifier,
                  builder: (context, categories, _) {
                    if (categories.isEmpty) {
                      return const Text('No categories available');
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.name,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Quantity
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.production_quantity_limits,
                        color: Colors.grey),
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Purchase Rate
                TextFormField(
                  controller: _purchaseRateController,
                  decoration: const InputDecoration(
                    labelText: 'Purchase Rate',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter purchase rate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Sales Rate
                TextFormField(
                  controller: _salesRateController,
                  decoration: const InputDecoration(
                    labelText: 'Sales Rate',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sales rate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.description, color: Colors.grey),
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveOrUpdateProduct,
                    child: Text(
                        widget.isEditing ? "Update Product" : "Save Product"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
