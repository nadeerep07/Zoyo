import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/text_field.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isEditing;
  final Map<String, String>? existingProduct;

  const AddUpdateScreen(
      {Key? key, this.isEditing = false, this.existingProduct})
      : super(key: key);

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController purchaseRateController = TextEditingController();
  final TextEditingController salesRateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.isEditing) {
      selectedCategory = widget.existingProduct?['category'];
    }
  }

  void _loadCategories() async {
    if (!Hive.isBoxOpen('categories')) {
      await Hive.openBox('categories');
    }

    var box = Hive.box('categories');
    // Fetch categories from the box
    List categories = box.get('categories', defaultValue: []);

    setState(() {
      // Update state with the loaded categories
      categories = categories.cast<String>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController productNameController = TextEditingController(
        text: widget.isEditing ? widget.existingProduct!['product'] : "");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back)),
        title: Text(widget.isEditing ? "Edit Product" : "Add Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )..add(
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ),
              ),
              SizedBox(height: 16),
              buildTextField('Product Name', productNameController),
              buildTextField('Product Code', productCodeController),
              buildTextField('Size', sizeController),
              buildTextField('Type', typeController),

              // **Dropdown for Selecting Category**
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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

              buildTextField('Quantity', quantityController),
              buildTextField('Purchase Rate', purchaseRateController,
                  prefix: '\$'),
              buildTextField('Sales Rate', salesRateController, prefix: '\$'),
              buildTextField('Product description', descriptionController,
                  maxLines: 3),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (widget.isEditing) {
                      print("Updating Product...");
                    } else {
                      print("Adding Product...");
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.isEditing ? "Update Product" : "Add Product",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
