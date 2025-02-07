import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/text_field.dart';

class DescriptionSection extends StatelessWidget {
  final TextEditingController descriptionController;

  const DescriptionSection({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        buildTextField('Product Description', descriptionController,
            maxLines: 3, icon: Icons.description),
        SizedBox(height: 20),
      ],
    );
  }
}
