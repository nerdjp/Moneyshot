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
  Category currentCategory = Category('');
  int editingTile = -1;
  TextEditingController categoryEditingController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void loadCategories() {
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
                try {
                  Category currentCategory = categories.elementAt(i);
                  setState(() {
                    service.remove(currentCategory);
                    loadCategories();
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
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: "You can only delete empty categories");
                }
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
                if (categoryEditingController.text.trim() == '') {
                  Fluttertoast.showToast(msg: "Description is empty!");
                  return;
                }
                setState(() {
                  currentCategory.description = categoryEditingController.text;
                  service.save(currentCategory);
                  editingTile = -1;
                  loadCategories();
                });
              }),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadCategories();
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
              currentCategory = Category('');
              categories.add(currentCategory);
              editingTile = categories.length - 1;
              myFocusNode.requestFocus();
            });
          },
        ));
  }
}
