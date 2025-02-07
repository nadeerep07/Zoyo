import 'package:flutter/material.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/custom_classes.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/descriptin_section.dart';
import 'product_images_section.dart';
import 'product_details_section.dart';
import 'category_dropdown_section.dart';
import 'pricing_section.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isEditing;
  final Product? existingProduct;

  const AddUpdateScreen({
    super.key,
    this.isEditing = false,
    this.existingProduct,
  });

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  late FormControllers _formControllers;
  late CategoryHandler _categoryHandler;
  late ImagePickerHandler _imagePickerHandler;
  late ProductSubmissionHandler _productSubmissionHandler;

  @override
  void initState() {
    super.initState();
    _formControllers = FormControllers(widget.existingProduct);
    _categoryHandler = CategoryHandler();
    _imagePickerHandler = ImagePickerHandler();
    _productSubmissionHandler = ProductSubmissionHandler(
      formControllers: _formControllers,
      imagePickerHandler: _imagePickerHandler,
      isEditing: widget.isEditing,
      existingProduct: widget.existingProduct,
    );
    _categoryHandler.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(widget.isEditing ? "Edit Product" : "Add Product",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProductImagesSection(
                  selectedImages: _imagePickerHandler.selectedImages,
                  pickImages: _imagePickerHandler.pickImages),
              ProductDetailsSection(
                productNameController: _formControllers.productNameController,
                productCodeController: _formControllers.productCodeController,
                sizeController: _formControllers.sizeController,
                typeController: _formControllers.typeController,
              ),
              CategoryDropdownSection(
                selectedCategory: _categoryHandler.selectedCategory,
                categories: _categoryHandler.categories,
                onChanged: (newValue) {
                  setState(() {
                    _categoryHandler.selectedCategory = newValue;
                  });
                },
              ),
              PricingSection(
                quantityController: _formControllers.quantityController,
                purchaseRateController: _formControllers.purchaseRateController,
                salesRateController: _formControllers.salesRateController,
              ),
              DescriptionSection(
                  descriptionController:
                      _formControllers.descriptionController),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () =>
                      _productSubmissionHandler.submitForm(context),
                  icon: Icon(widget.isEditing ? Icons.update : Icons.add,
                      color: Colors.white),
                  label: Text(
                      widget.isEditing ? "Update Product" : "Add Product",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
