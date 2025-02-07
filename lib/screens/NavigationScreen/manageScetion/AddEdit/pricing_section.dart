import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/NavigationScreen/manageScetion/AddEdit/text_field.dart';

class PricingSection extends StatelessWidget {
  final TextEditingController quantityController;
  final TextEditingController purchaseRateController;
  final TextEditingController salesRateController;

  const PricingSection({
    super.key,
    required this.quantityController,
    required this.purchaseRateController,
    required this.salesRateController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pricing",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        buildTextField('Quantity', quantityController,
            icon: Icons.format_list_numbered),
        buildTextField('Purchase Rate', purchaseRateController, prefix: '₹'),
        buildTextField('Sales Rate', salesRateController, prefix: '₹'),
        SizedBox(height: 16),
      ],
    );
  }
}
