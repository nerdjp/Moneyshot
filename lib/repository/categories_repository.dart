import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/repository/database_helper.dart';

class CategoriesRepository extends DatabaseHelper<Category> {
  @override
  String _table = "categories";

  CategoriesRepository();

  @override
  String getTable() {
    return 'categories';
  }

  @override
  Category transform(Map<String, Object?> map) {
    return Category.withId(map['id'] as int, map['description'] as String);
  }
}
