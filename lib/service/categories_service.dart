import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/entity/spendings.dart';
import 'package:moneyshot/repository/categories_repository.dart';

class CategoriesService {
  final CategoriesRepository _repo = CategoriesRepository();
  static final CategoriesService _instance = CategoriesService._privateConstructor();
  List<Category> categories = [];

  factory CategoriesService() => _instance;
  //static Future<CategoriesService> getInstance() async {
    //if(_instance == null) {
      //_instance = CategoriesService._privateConstructor();
      //await _instance!.init();
    //}
    //return _instance!;
  //}
  CategoriesService._privateConstructor();

  //Future<void> init() async {
    //await getAll().then((value) {
      //_categories = value;
    //});
  //}

  Future<List<Category>> getAll() {
    return _repo.getAll();
  }

  void save(Category newCategory) {
    if(categories.contains(newCategory)) return;
    categories.add(newCategory);
    _repo.save(newCategory);
  }

  void remove(Category category) {
    _repo.remove(category);
    categories.remove(category);
  }

  Category getCategoryAt(int index) {
    return categories[index];
  }

  void addTemporary(Category category) {
    categories.add(category);
  }

  void removeTemporary(Category category) {
    categories.remove(category);
  }

  int totalCategories() {
    return categories.length;
  }

  addSpending(Category category, DateTime date, String desc, double value,
      DateTime? paymentDate, int? installments, int? totalInstallments) {
    category.spendings.add(Spendings(date, desc, value, category, paymentDate,
        installments, totalInstallments));
  }
}
