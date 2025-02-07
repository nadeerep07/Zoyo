import 'dart:io';
import 'package:flutter/material.dart';
import 'image_picker.dart';

class ProductImagesSection extends StatefulWidget {
  final List<File> selectedImages;
  final Function pickImages;

  const ProductImagesSection(
      {super.key, required this.selectedImages, required this.pickImages});

  @override
  _ProductImagesSectionState createState() => _ProductImagesSectionState();
}

class _ProductImagesSectionState extends State<ProductImagesSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Images",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            ...widget.selectedImages.map((image) {
              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectedImages.remove(image);
                        });
                      },
                      child: Icon(Icons.cancel, color: Colors.red),
                    ),
                  ),
                ],
              );
            }),
            if (widget.selectedImages.length < 5)
              IconButton(
                icon: Icon(Icons.add_a_photo, color: Colors.blue),
                onPressed: () => widget.pickImages(),
              ),
          ],
        ),
      ],
    );
  }
}
