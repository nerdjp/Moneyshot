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
            Spendings currentListItem = SpendingsService().getSpendings().elementAt(i);
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      currentListItem.description,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          currentListItem.category.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(DateFormat.yMd().format(currentListItem.date)),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Text(
                          'R\$ ' + currentListItem.value.toStringAsFixed(2),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
              onLongPress: () { Fluttertoast.showToast(msg: currentListItem.toString()); },
            );
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
                  if(desc == null || desc.isEmpty) {
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
              SpendingsService().save(Spendings(date, description, value, category!, paymentDate, installments, totalInstallments));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
