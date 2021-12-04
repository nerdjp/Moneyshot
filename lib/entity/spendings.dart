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

  Spendings.withInstallments(this.date, this.description, this.value,
      this.category, this.installment, this.totalInstallment);

  @override
  Map<String, Object?> toJson() => {
        '_id': id,
        'description': description,
        'date': date,
        'category_id': category.id,
        'value': value,
        'date_payment': datePayment?.toIso8601String(),
        'n_installments': installment,
        'nt_installments': totalInstallment,
      };
}
