import 'package:moneyshot/entity/expense.dart';
import 'package:moneyshot/repository/expenses_repository.dart';
import 'package:moneyshot/service/categories_service.dart';

class ExpensesService {
  final ExpensesRepository _repo = ExpensesRepository();
  static final ExpensesService _instance =
      ExpensesService._privateConstructor();
  List<Expense> _expenses = [];

  factory ExpensesService() => _instance;
  ExpensesService._privateConstructor();

  Future<void> init() async {
    await _repo.getAll().then((expensesLoaded) {
      _expenses = expensesLoaded;
      for (int i = 0; i < _expenses.length; i++) {
        CategoriesService().addSpending(_expenses[i].category, _expenses[i]);
      }
    });
  }

  List<Expense> getExpenses() {
    return _expenses;
  }

  Expense getExpenseById(int id) {
    return _expenses.singleWhere((expense) => expense.id == id);
  }

  Expense getAt(int index) {
    return _expenses[index];
  }

  void save(Expense expense) {
    if (expense.id == null) {
      _expenses.add(expense);
    }
    CategoriesService().addSpending(expense.category, expense);
    _repo.save(expense);
  }

  void remove(Expense expense) {
    _expenses.remove(expense);
    _repo.remove(expense);
  }

  int totalCategories() {
    return _expenses.length;
  }
}
