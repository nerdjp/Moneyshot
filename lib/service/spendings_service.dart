import 'package:moneyshot/entity/spendings.dart';
import 'package:moneyshot/repository/spendings_repository.dart';
import 'package:moneyshot/service/categories_service.dart';

class SpendingsService {
  final SpendingsRepository _repo = SpendingsRepository();
  static final SpendingsService _instance = SpendingsService._privateConstructor();
  List<Spendings> _spendings = [];

  factory SpendingsService() => _instance;
  SpendingsService._privateConstructor();

  Future<void> init() async {
    await _repo.getAll().then((spendingsLoaded) {
      _spendings = spendingsLoaded;
      for(int i = 0; i < _spendings.length; i++) {
        CategoriesService().addSpending(_spendings[i].category, _spendings[i]);
      }
    });
  }

  List<Spendings> getSpendings() {
    return _spendings;
  }

  Spendings getSpendingById(int id) {
    return _spendings.singleWhere((spending) => spending.id == id);
  }

  Spendings getAt(int index) {
    return _spendings[index];
  }

  void save(Spendings spending) {
    if(spending.id == null) {
      _spendings.add(spending);
    }
    CategoriesService().addSpending(spending.category, spending);
    _repo.save(spending);
  }

  void remove(Spendings spending) {
    _spendings.remove(spending);
    _repo.remove(spending);
  }

  int totalCategories() {
    return _spendings.length;
  }
}
