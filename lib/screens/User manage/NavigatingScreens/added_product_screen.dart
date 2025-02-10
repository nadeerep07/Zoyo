import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/User%20manage/Add%20And%20Edit/Product%20section/product_add_edit.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/utilitis/widgets/back_botton.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  late Box<Product> productBox;
  final TextEditingController _searchController = TextEditingController();
  bool isBoxOpened = false;

  @override
  void initState() {
    super.initState();
    _openBox();
    _searchController.addListener(_filterProducts);
  }

  Future<void> _openBox() async {
    try {
      productBox = await Hive.openBox<Product>('products');
      if (!mounted) return;
      setState(() {
        isBoxOpened = true;
      });
      getAllProducts();
    } catch (e) {
      log("Error opening box: $e");
    }
  }

  void _filterProducts() {
    if (!isBoxOpened || !productBox.isOpen) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isBoxOpened) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Added Stock"),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: const Text("Added Stock"),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search by Code",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Product>>(
              valueListenable: productsNotifier,
              builder: (context, List<Product> box, _) {
                final query = _searchController.text.trim().toLowerCase();
                final products = box.where((product) {
                  return product.productCode.toLowerCase().contains(query);
                }).toList();

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline,
                            size: 50, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          "No products found\nTap '+' to add a product.",
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: SizedBox(
                          width: 50, // Set a fixed width
                          height: 50,
                          child: product.imagePaths.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(product.imagePaths.first),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.image,
                                      size: 30, color: Colors.grey),
                                ),
                        ),
                        title: Text(
                          product.productName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Code: ${product.productCode}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),
                            ),
                            Text(
                              "Quantity: ${product.quantity}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueAccent),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductAddEdit(
                                      isEditing: true,
                                      existingProduct: product,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (!isBoxOpened || !productBox.isOpen) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Data is still loading. Please wait.")),
                                  );
                                  return;
                                }
                                deleteProduct(product.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductAddEdit(
                isEditing: false,
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
