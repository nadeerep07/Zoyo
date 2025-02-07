import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? imagePath;

  @HiveField(2)
  String id;

  Category({required this.name, this.imagePath, required this.id});
}
