import 'package:moneyshot/entity/spendings.dart';
import 'package:moneyshot/service/categories_service.dart';
import 'package:moneyshot/repository/database_helper.dart';

class SpendingsRepository extends DatabaseHelper<Spendings> {
  @override
  String getTable() {
    return 'spendings';
  }

  @override
  Spendings transform(Map<String, Object?> map) {
    return Spendings.withId(
      map['id'] as int,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['description'] as String,
      map['value'] as double,
      CategoriesService().getCategoryById(map['category_id'] as int),
      map['date_payment'] != null ? DateTime.fromMillisecondsSinceEpoch(map['date_payment'] as int) : null,
      map['n_installment'] as int?,
      map['nt_installment'] as int?,
    );
  }
}
