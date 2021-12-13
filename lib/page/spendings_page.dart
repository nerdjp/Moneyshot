import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/entity/spendings.dart';
import 'package:moneyshot/service/spendings_service.dart';
import 'package:moneyshot/service/categories_service.dart';

class SpendingsPage extends StatefulWidget {
  const SpendingsPage({Key? key}) : super(key: key);
  @override
  _SpendingsPageState createState() => _SpendingsPageState();
}

class _SpendingsPageState extends State<SpendingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: SpendingsService().getSpendings().length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            Spendings spending = SpendingsService().getSpendings()[i];
            return ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                spending.description,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    spending.category.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(DateFormat.yMd().format(spending.date)),
                ),
              ],
            ),
            trailing: Text(
              'R\$ ' + spending.value.toStringAsFixed(2),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            //Expanded widget
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      FieldBox(
                        title: 'Data de criação',
                        child: Center(
                            child: Text(DateFormat.yMd()
                                .format(spending.date))),
                      ),
                      FieldBox(
                        title: 'Data de pagamento',
                        child: Text(
                          spending.datePayment == null
                              ? "Não pago"
                              : DateFormat.yMd().format(
                                  spending.datePayment ??
                                      spending.date),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FieldBox(
                        title: 'Parcelas',
                        child: Text(spending.installment == null
                            ? 'Não há parcelas'
                            : spending.installment.toString()),
                      ),
                      if (spending.totalInstallment != null)
                        FieldBox(
                          title: 'Total de parcelas',
                          child: Text(
                              spending.totalInstallment.toString()),
                        ),
                    ],
                  ),
                ],
              ),
            ]);
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          if (CategoriesService().getCategories().isNotEmpty) {
            showDialog(
              context: context,
              builder: (_) => const AddSpending()).then((_) {
                setState((){});
              });
          } else {
            Fluttertoast.showToast(msg: "Add a category first! ");
          }
        },
      ),
    );
  }
}

class FieldBox extends StatelessWidget {
  const FieldBox({
    required this.child,
    Key? key,
    this.flex = 1,
    this.title = '',
  }) : super(key: key);

  final Widget child;
  final int flex;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InputDecorator(
          expands: false,
          decoration: InputDecoration(
            isDense: true,
            labelText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class AddSpending extends StatefulWidget {
  const AddSpending({Key? key}) : super(key: key);

  @override
  State<AddSpending> createState() => _AddSpendingState();
}

class _AddSpendingState extends State<AddSpending> {
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
      title: const Text("Add Spending"),
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
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: const Text("Category"),
                      value: category,
                      items: CategoriesService().getCategories().map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.description),
                        );
                      }).toList(),
                      validator: (value) {
                        if(value == null) {
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
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Value",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
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
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
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
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
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
              SpendingsService().save(Spendings(date, description, value,
                  category!, paymentDate, installments, totalInstallments));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
