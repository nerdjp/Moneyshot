import 'package:flutter/material.dart';
import 'package:moneyshot/service/expenses_service.dart';
import 'package:moneyshot/entity/expense.dart';
import 'package:moneyshot/service/categories_service.dart';
import 'package:moneyshot/entity/category.dart';

class PlanningPage extends StatefulWidget {
  const PlanningPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: CategoriesService().totalCategories(),
        itemBuilder: (context, i) {
          Category currentCategory = CategoriesService().getAt(i);
          return ListTile(
            title: Text(currentCategory.description),
            trailing: Text(currentCategory.totalValue.toStringAsFixed(2)),
          );
        });
  }
}
