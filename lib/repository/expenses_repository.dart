import 'package:moneyshot/entity/expense.dart';
import 'package:moneyshot/service/categories_service.dart';
import 'package:moneyshot/repository/database_helper.dart';

class ExpensesRepository extends DatabaseHelper<Expense> {
  @override
  String getTable() {
    return 'expenses';
  }

  @override
  Expense transform(Map<String, Object?> map) {
    return Expense.withId(
      map['id'] as int,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['description'] as String,
      map['value'] as double,
      CategoriesService().getCategoryById(map['category_id'] as int),
      map['date_payment'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date_payment'] as int)
          : null,
      map['n_installments'] as int?,
      map['nt_installments'] as int?,
    );
  }
}
