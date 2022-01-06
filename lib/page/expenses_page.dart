import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/entity/expense.dart';
import 'package:moneyshot/service/expenses_service.dart';
import 'package:moneyshot/service/categories_service.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: ExpensesService().getExpenses().length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            Expense expense = ExpensesService().getExpenses()[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    expense.description,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        expense.category.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(DateFormat.yMd().format(expense.date)),
                    ),
                  ],
                ),
                trailing: Text(
                  'R\$ ' + expense.value.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                //Expanded widget
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          FieldBox(
                            title: 'Data de criação',
                            child: Center(
                                child: Text(
                                    DateFormat.yMd().format(expense.date))),
                          ),
                          FieldBox(
                            title: 'Data de pagamento',
                            child: Text(
                              expense.datePayment == null
                                  ? "Não pago"
                                  : DateFormat.yMd().format(
                                      expense.datePayment ?? expense.date),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FieldBox(
                            title: 'Parcelas',
                            child: Text(expense.installment == null
                                ? 'Não há parcelas'
                                : expense.installment.toString()),
                          ),
                          if (expense.totalInstallment != null)
                            FieldBox(
                              title: 'Total de parcelas',
                              child: Text(expense.totalInstallment.toString()),
                            ),
                        ],
                      ),
                      TextButton(
                        child: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => ExpenseDeletePopup(
                              expense: expense,
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          if (CategoriesService().getCategories().isNotEmpty) {
            showDialog(context: context, builder: (_) => const AddExpense())
                .then((_) {
              setState(() {});
            });
          } else {
            Fluttertoast.showToast(msg: "Add a category first! ");
          }
        },
      ),
    );
  }
}

class ExpenseDeletePopup extends StatelessWidget {
  const ExpenseDeletePopup({Key? key, required this.expense}) : super(key: key);
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${expense.description}?"),
      actions: [
        //TextButton(onPressed: OwO, child: child)
        TextButton(
          child: const Text("Delete"),
          onPressed: () {
            expense.category.expenses.remove(expense);
            ExpensesService().remove(expense);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class FieldBox extends StatelessWidget {
  const FieldBox({
    Key? key,
    required this.child,
    this.title = '',
    this.flex = 1,
    this.padding = 10.0,
    this.radius = 8.0,
  }) : super(key: key);

  final Widget child;
  final int flex;
  final String title;
  final double padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InputDecorator(
          decoration: InputDecoration(
            isCollapsed: true,
            labelText: title,
            border: const OutlineInputBorder(),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  DateTime date = DateTime.now();
  late String description;
  late double value;
  Category? category;
  DateTime? paymentDate;
  int? installments;
  int? totalInstallments;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Expense"),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (desc) {
                  if (desc == null || desc.isEmpty) {
                    return 'Please fill the description';
                  }
                },
                onChanged: (desc) {
                  description = desc;
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          CategoriesService().getCategories().map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.description),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please pick a category';
                        }
                      },
                      onChanged: (Category? newCategory) {
                        if (newCategory != null) {
                          setState(() {
                            category = newCategory;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Value",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the price';
                        }
                      },
                      onChanged: (val) {
                        value = double.parse(val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                FieldBox(
                  title: 'Data de Criação',
                  padding: 0,
                  child: TextButton(
                    child: Text(DateFormat.yMd().format(date)),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2041),
                      ).then((datePicked) {
                        if (datePicked != null) {
                          setState(() {
                            date = datePicked;
                          });
                        }
                      });
                    },
                  ),
                ),
                FieldBox(
                  title: paymentDate == null ? '' : 'Data Pagamento',
                  padding: 0,
                  child: TextButton(
                    child: Text(paymentDate == null
                        ? "Data Pagamento"
                        : DateFormat.yMd().format(paymentDate ?? date)),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2041),
                      ).then((datePicked) {
                        if (datePicked != null) {
                          setState(() {
                            paymentDate = datePicked;
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Installments (Optional)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (ins) {
                        installments = int.parse(ins);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Total Installments (Optional)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (ins) {
                        totalInstallments = int.parse(ins);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Icon(Icons.check),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ExpensesService().save(Expense(date, description, value,
                  category!, paymentDate, installments, totalInstallments));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
