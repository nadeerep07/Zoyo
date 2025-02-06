import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String code;

  @HiveField(2)
  String size;

  @HiveField(3)
  String type;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  double purchaseRate;

  @HiveField(6)
  double salesRate;

  @HiveField(7)
  String description;

  @HiveField(8)
  String category;

  @HiveField(9)
  List<String> imagePaths;

  @HiveField(10)
  String? id;

  Product({
    required this.title,
    required this.code,
    required this.size,
    required this.type,
    required this.quantity,
    required this.purchaseRate,
    required this.salesRate,
    required this.description,
    required this.category,
    required this.imagePaths,
    required this.id,
  });
  @override
  String toString() {
    return 'Product{title: $title, code: $code, size: $size, type: $type, quantity: $quantity, purchaseRate: $purchaseRate, salesRate: $salesRate, description: $description, category: $category, imagePaths: $imagePaths id: $id}';
  }
}
