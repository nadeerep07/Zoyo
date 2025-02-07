import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/CrudOperations/data_services.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/add_update_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  late Box<Product> productBox;
  final TextEditingController _searchController = TextEditingController();
  bool isBoxOpened = false; // Track whether the box is opened

  @override
  void initState() {
    super.initState();
    _openBox();
    _searchController.addListener(_filterProducts);
  }

  Future<void> _openBox() async {
    productBox = await Hive.openBox<Product>('products');
    setState(() {
      isBoxOpened = true;
    });
  }

  void _filterProducts() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isBoxOpened) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Added Stock"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Added Stock"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by Code",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Product>>(
              valueListenable: DatabaseHelper.productsNotifier,
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
                        Icon(Icons.add_circle_outline,
                            size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "No products found\nTap '+' to add a product.",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 5,
                      child: ListTile(
                        leading: product.imagePaths.isNotEmpty
                            ? Image.file(
                                File(product.imagePaths.first),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, size: 50, color: Colors.grey),
                        title: Text(product.productName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(
                            "Code: ${product.productCode}\nCategory: ${product.category}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddUpdateScreen(
                                      isEditing: true,
                                      existingProduct: product,
                                      // existingProduct: {
                                      //   'product': product.productName,
                                      //   'productCode': product.productCode,
                                      //   'category': product.category,
                                      //   'size': product.size,
                                      //   'type': product.type,
                                      //   'quantity': product.quantity.toString(),
                                      //   'purchaseRate':
                                      //       product.purchaseRate.toString(),
                                      //   'salesRate':
                                      //       product.salesRate.toString(),
                                      //   'description': product.description,
                                      //   'imagePaths':
                                      //       product.imagePaths.join(','),
                                      // },
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                productBox.delete(product.key);
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
              builder: (context) => AddUpdateScreen(isEditing: false),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
