import 'package:flutter/material.dart';

class CategoryDropdownSection extends StatelessWidget {
  final String? selectedCategory;
  final List<String> categories;
  final Function(String?) onChanged;

  const CategoryDropdownSection({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Category",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: InputDecoration(
            labelText: "Category",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: Icon(Icons.category, color: Colors.blue),
          ),
          items: categories
              .map((category) =>
                  DropdownMenuItem(value: category, child: Text(category)))
              .toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
