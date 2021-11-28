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
  CategoriesService service = CategoriesService();
  List<Category> categories = [];
  int editingTile = -1;
  TextEditingController categoryEditingController = TextEditingController();

  void initCategories() {
    service.getAll().then((value) => categories = value);
  }

  ListTile makeCategoryListTile(int i) {
    return ListTile(
      title: Text(categories[i].description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  editingTile = i;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Icon(Icons.delete),
              onPressed: () {
                /*Category currentCategory = Category.categories.elementAt(i);
                if (currentCategory.spendings.isEmpty) {
                  setState(() {
                    //Category.removeCategory(currentCategory);
                  });
                  SnackBar snackBar = SnackBar(
                    content: Text(
                        "Category ${currentCategory.description.toString()} deleted."),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() {
                          categories.add(currentCategory);
                        });
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Fluttertoast.showToast(
                      msg: "You can only delete empty categories");
                }*/
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile makeEditableCategoryListTile(int i) {
    Category currentCategory = categories.elementAt(i);
    categoryEditingController.text = currentCategory.description;
    return ListTile(
      title: TextField(
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
                categoryEditingController.clear();
                setState(() {
                  editingTile = -1;
                });
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              child: const Icon(Icons.check),
              onPressed: () {
                /*Category.editCategory(
                    currentCategory, categoryEditingController.text);*/
                setState(() {
                  editingTile = -1;
                });
              }),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    initCategories();
    return Scaffold(
        body: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, i) {
              if (i == editingTile) {
                return makeEditableCategoryListTile(i);
              } else {
                return makeCategoryListTile(i);
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              //Category.createCategory("New Category");
            });
          },
        ));
  }
}
