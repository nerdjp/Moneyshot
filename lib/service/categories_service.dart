import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/entity/spendings.dart';
import 'package:moneyshot/repository/categories_repository.dart';

class CategoriesService {
  final CategoriesRepository _repo = CategoriesRepository();
  static final CategoriesService _instance = CategoriesService._privateConstructor();
  List<Category> _categories = [];

  factory CategoriesService() => _instance;

  CategoriesService._privateConstructor();

  Future<void> init() async {
    await _repo.getAll().then((categoriesLoaded) {
      _categories = categoriesLoaded;
    });
  }

  List<Category> getCategories() {
    return _categories;
  }

  Category getCategoryById(int id) {
    return _categories.singleWhere((category) => category.id == id);
  }

  Category getAt(int index) {
    return _categories[index];
  }

  void save(Category newCategory) {
    if(newCategory.id == null) {
      _categories.add(newCategory);
    }
    _repo.save(newCategory);
  }

  void remove(Category category) {
    _repo.remove(category);
    _categories.remove(category);
  }

  int totalCategories() {
    return _categories.length;
  }

  addSpending(Category category, Spendings spending) {
    if(!category.spendings.contains(spending)) {
      category.spendings.add(spending);
    }
  }
}
