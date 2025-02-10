import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/services/clipper_shape.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class ProductCarousel extends StatelessWidget {
  final List<Product> products;

  const ProductCarousel({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 250,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.5,
          autoPlay: false,
        ),
        items: products.map((product) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  ClipPath(
                    clipper: RoundedCustomClipper(),
                    child: Container(
                      width: 130,
                      height: 130,
                      color: AppColors.primaryColor,
                      child: Image.asset(
                        product.imagePaths.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.productName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
