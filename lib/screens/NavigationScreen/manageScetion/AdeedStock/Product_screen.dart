import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/add_update_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  late Box<Product> productBox;
  TextEditingController _searchController = TextEditingController();
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('products');
    _searchController.addListener(_filterProducts);
    _filterProducts();
  }

  void _filterProducts() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredProducts = productBox.values.toList();
      });
    } else {
      setState(() {
        filteredProducts = productBox.values
            .where((product) => product.code.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Added Stock")),
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
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: productBox.listenable(),
                builder: (context, Box<Product> box, _) {
                  if (filteredProducts.isEmpty) {
                    return Center(child: Text("No products found"));
                  }
                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          leading: Image.asset(
                            product.imagePaths.first,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.title,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              "Code: ${product.code}\nCategory: ${product.category}"),
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
                                        existingProduct: {
                                          'title': product.title,
                                          'code': product.code,
                                          'category': product.category,
                                          'imagePaths':
                                              product.imagePaths.join(','),
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  productBox.delete(product.key);
                                  _filterProducts();
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
        ));
  }
}
