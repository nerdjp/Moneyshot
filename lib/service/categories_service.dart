import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/repository/categories_repository.dart';

class CategoriesService {
  CategoriesRepository _repo = CategoriesRepository();

  Future<List<Category>> getAll() async {
    return _repo.getAll();
  }

  Future<void> save(Category category) async {
    _repo.save(category);
  }

  Future<int> remove(Category category) {
    return _repo.remove(category);
  }

  /*static void createCategory(String description) async {
    Category temp = Category(description);
    temp.id = await DatabaseHelper.instance.createCategory(temp);
  }

  static void removeCategory(Category category) async {
    DatabaseHelper.instance.removeCategory(category.id);
    categories.remove(category);
  }

  static void editCategory(Category category, String newDescription) async {
    DatabaseHelper.instance.updateCategory(category);
    category.description = newDescription;
  }

  addSpending(DateTime date, String desc, double value, DateTime? paymentDate,
      int? installments, int? totalInstallments) {
    spendings.add(Spendings(
        date, desc, value, this, paymentDate, installments, totalInstallments));
  }

  static Future initCategories() async {
    final dbCategories = await DatabaseHelper.instance.read(categoryTable);

    if (dbCategories.isEmpty) return;

    for (int i = 0; i < dbCategories.length; i++) {
      final categoryInfo = dbCategories.elementAt(i);
      print(categoryInfo.toString());
      categories.add(Category.withId(
          categoryInfo['id'] as int, categoryInfo['description'] as String));
    }
  }*/
}
