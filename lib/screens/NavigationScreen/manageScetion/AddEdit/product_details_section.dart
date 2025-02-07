import 'package:flutter/material.dart';

Widget buildTextField(String label, TextEditingController controller,
    {IconData? icon, int maxLines = 1, String? prefix}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
      prefix: prefix != null ? Text(prefix) : null,
    ),
    maxLines: maxLines,
  );
}

class ProductDetailsSection extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController productCodeController;
  final TextEditingController sizeController;
  final TextEditingController typeController;

  const ProductDetailsSection({
    super.key,
    required this.productNameController,
    required this.productCodeController,
    required this.sizeController,
    required this.typeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        buildTextField('Product Name', productNameController,
            icon: Icons.shopping_bag),
        SizedBox(
          height: 8,
        ),
        buildTextField('Product Code', productCodeController, icon: Icons.code),
        SizedBox(
          height: 8,
        ),
        buildTextField('Size', sizeController, icon: Icons.straighten),
        SizedBox(
          height: 8,
        ),
        buildTextField('Type', typeController, icon: Icons.category),
        SizedBox(height: 16),
      ],
    );
  }
}
