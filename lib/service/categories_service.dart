import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/entity/spendings.dart';
import 'package:moneyshot/repository/categories_repository.dart';

class CategoriesService {
  final CategoriesRepository _repo = CategoriesRepository();
  static final CategoriesService _instance =
      CategoriesService._privateConstructor();
  List<Category> categories = [];

  factory CategoriesService() => _instance;
  CategoriesService._privateConstructor();

  // TODO: Procurar melhor alternativa
  Future<void> init() async {
    await getAll().then((value) {
      categories = value;
    });
  }

  Future<List<Category>> getAll() async {
    return _repo.getAll();
  }

  void save(Category newCategory) {
    if (categories.where((category) => category.id == newCategory.id).isEmpty) {
      categories.add(newCategory);
    }
    _repo.save(newCategory);
  }

  void remove(Category category) {
    _repo.remove(category);
    categories.remove(category);
  }

  addSpending(Category category, DateTime date, String desc, double value,
      DateTime? paymentDate, int? installments, int? totalInstallments) {
    category.spendings.add(Spendings(date, desc, value, category, paymentDate,
        installments, totalInstallments));
  }
}
