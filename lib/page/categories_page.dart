import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moneyshot/entity/category.dart';
import 'package:moneyshot/service/categories_service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late CategoriesService service = CategoriesService();
  late Category currentCategory;
  int editingIndex = -1;
  TextEditingController categoryEditingController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    service.init().then((value) {
      setState((){});
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  ListTile makeCategoryListTile(int index) {
    return ListTile(
      title: Text(currentCategory.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Icon(Icons.edit),
              onPressed: () {
                editingIndex = index;
                myFocusNode.requestFocus();
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Icon(Icons.delete),
              onPressed: () {
                Fluttertoast.showToast(msg: "category: $currentCategory");
                if (currentCategory.spendings.isNotEmpty) {
                  Fluttertoast.showToast(
                      msg: "You can only delete empty categories");
                  return;
                }
                setState(() {
                  service.remove(service.categories[index]);
                });
                SnackBar snackBar = SnackBar(
                  content: Text(
                      "Category ${currentCategory.description.toString()} deleted."),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () async {
                      setState(() {
                        service.save(currentCategory);
                      });
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile makeEditableCategoryListTile(int index) {
    Category currentCategory = service.categories[index];
    categoryEditingController.text = currentCategory.description;

    return ListTile(
      title: TextField(
        focusNode: myFocusNode,
        controller: categoryEditingController,
        decoration: InputDecoration(
          hintText: currentCategory.description,
          border: const OutlineInputBorder(),
        ),
      ),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              child: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  categoryEditingController.clear();
                  editingIndex = -1;
                  if(currentCategory.id == null) service.categories.remove(currentCategory);
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: const Icon(Icons.check),
            onPressed: () {
              if (categoryEditingController.text.trim() == '') {
                Fluttertoast.showToast(msg: "Description is empty!");
                return;
              }
              currentCategory.description = categoryEditingController.text;
              service.save(currentCategory);
              editingIndex = -1;
              setState(() {});
            },
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: service.categories.length,
          itemBuilder: (context, i) {
            currentCategory = service.categories[i];
            if (i == editingIndex) {
              return makeEditableCategoryListTile(i);
            } else {
              return makeCategoryListTile(i);
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            editingIndex = service.categories.length;
            currentCategory = Category('');
            service.categories.add(currentCategory);
            myFocusNode.requestFocus();
          });
        },
      ),
    );
  }
}
