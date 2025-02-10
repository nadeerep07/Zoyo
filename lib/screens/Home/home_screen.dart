import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/Cart%20Section/CArt_screen.dart';
import 'package:zoyo_bathware/screens/Home/search_screen.dart';
import 'package:zoyo_bathware/screens/Products/all_categories.dart';
import 'package:zoyo_bathware/screens/User%20manage/manage_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';
import 'package:zoyo_bathware/database/product_model.dart';
import 'package:zoyo_bathware/utilitis/widgets/bottom_navigation.dart';
import 'package:zoyo_bathware/utilitis/widgets/carousel_silder.dart';
import 'package:zoyo_bathware/utilitis/widgets/product_carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllCategories()),
        );
        break;
      // case 2:
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ImportedScreen()),
      //   );
      //   break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.primaryColor,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.view_list,
              size: 32,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image.asset(
                'assets/images/Screenshot 2025-02-03 at 8.38.37 PM.png',
                height: 100,
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(
                Icons.search,
                size: 32,
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CustomCarouselSlider(
                  imagePaths: [
                    'assets/images/PHOTO-2025-02-03-18-58-20.jpg',
                    'assets/images/PHOTO-2025-02-03-18-58-20.jpg',
                    'assets/images/PHOTO-2025-02-03-18-58-20.jpg',
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(color: AppColors.buttonColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: ProductCarousel(products: products),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        //bottom navigation in utilities/widgets
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
