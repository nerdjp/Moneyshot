import 'dart:core';
import 'package:moneyshot/entity/category.dart';
import 'entity.dart';

class Spendings extends Entity {
  String description;
  DateTime date;
  Category category;
  double value;
  DateTime? datePayment;
  int? installment;
  int? totalInstallment;
  bool isPaid = false;

  Spendings(this.date, this.description, this.value, this.category,
    this.datePayment, this.installment, this.totalInstallment) {
    isPaid = datePayment != null ? true : false;
  }

  Spendings.withId(int id, this.date, this.description, this.value, this.category,
    this.datePayment, this.installment, this.totalInstallment) {
    super.id = id;
    isPaid = datePayment != null ? true : false;
  }

  @override
  Map<String, Object?> toJson() => {
        'id': id,
        'description': description,
        'date': date.millisecondsSinceEpoch,
        'category_id': category.id,
        'value': value,
        'date_payment': datePayment?.millisecondsSinceEpoch,
        'n_installments': installment,
        'nt_installments': totalInstallment,
  };
}
