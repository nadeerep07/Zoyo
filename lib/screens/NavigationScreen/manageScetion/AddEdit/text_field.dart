import 'package:flutter/material.dart';

Widget buildTextField(String label, TextEditingController controller,
    {String? prefix, int maxLines = 1, IconData? icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
      ),
    ),
  );
}
