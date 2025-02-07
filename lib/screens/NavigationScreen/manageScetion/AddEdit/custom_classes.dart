import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/database/category_model.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/image_picker.dart';
import 'package:zoyo_bathware/utilitis/unique_id.dart';

class FormControllers {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController purchaseRateController = TextEditingController();
  final TextEditingController salesRateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  FormControllers(Product? existingProduct) {
    if (existingProduct != null) {
      productNameController.text = existingProduct.productName;
      productCodeController.text = existingProduct.productCode;
      sizeController.text = existingProduct.size;
      typeController.text = existingProduct.type;
      quantityController.text = existingProduct.quantity.toString();
      purchaseRateController.text = existingProduct.purchaseRate.toString();
      salesRateController.text = existingProduct.salesRate.toString();
      descriptionController.text = existingProduct.description;
    }
  }
}

class CategoryHandler {
  String? selectedCategory;
  List<String> categories = [];

  void loadCategories() async {
    if (!Hive.isBoxOpen('categories')) {
      await Hive.openBox<Category>('categories');
    }
    var box = Hive.box<Category>('categories');
    categories = box.values.map((category) => category.name).toList();
  }
}

class ImagePickerHandler {
  List<File> selectedImages = [];

  Future<void> pickImages() async {
    List<File> pickedImages = await ImagePickerHelper().pickMultipleImages();
    if (pickedImages.isNotEmpty) {
      selectedImages.addAll(pickedImages);
    }
  }
}

class ProductSubmissionHandler {
  final FormControllers formControllers;
  final ImagePickerHandler imagePickerHandler;
  final bool isEditing;
  final Product? existingProduct;

  ProductSubmissionHandler({
    required this.formControllers,
    required this.imagePickerHandler,
    required this.isEditing,
    this.existingProduct,
  });

  void submitForm(BuildContext context) async {
    if (formControllers.productNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all required fields")));
      return;
    }

    String uniqueProductId =
        isEditing ? existingProduct?.id ?? '' : generateUniqueId();

    Product newProduct = Product(
      id: uniqueProductId,
      productName: formControllers.productNameController.text,
      productCode: formControllers.productCodeController.text,
      size: formControllers.sizeController.text,
      type: formControllers.typeController.text,
      category: existingProduct?.category ?? '',
      quantity: int.parse(formControllers.quantityController.text),
      purchaseRate: double.parse(formControllers.purchaseRateController.text),
      salesRate: double.parse(formControllers.salesRateController.text),
      description: formControllers.descriptionController.text,
      imagePaths:
          imagePickerHandler.selectedImages.map((image) => image.path).toList(),
    );

    await DatabaseHelper.openBoxes();
    isEditing
        ? await DatabaseHelper.updateProduct(uniqueProductId, newProduct)
        : await DatabaseHelper.addProduct(newProduct);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEditing
            ? "Product Updated Successfully"
            : "Product Added Successfully")));
    Navigator.pop(context);
  }
}
