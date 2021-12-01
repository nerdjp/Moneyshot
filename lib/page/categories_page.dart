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
  late Category currentCategory;
  int editingTile = -1;
  TextEditingController categoryEditingController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    () async {
      await _loadCategories();
      setState(() {});
    }();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    categories = await service.getAll();
  }

  Future<void> _save(Category category) async {
    await service.save(category);
    await _loadCategories();
  }

  Future<void> _delete(Category category) async {
    await service.remove(category);
    await _loadCategories();
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
                editingTile = i;
                myFocusNode.requestFocus();
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Icon(Icons.delete),
              onPressed: () async {
                Category deletedCategory = categories.elementAt(i);
                Fluttertoast.showToast(msg: "category: ${deletedCategory}");
                //await _delete(deletedCategory);
                setState(() {});
                /*try {
                  
                  SnackBar snackBar = SnackBar(
                    content: Text(
                        "Category ${deletedCategory.description.toString()} deleted."),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        await _save(deletedCategory);
                        setState(() {});
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } catch (e) {
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
                editingTile = -1;
                setState(() {});
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              child: const Icon(Icons.check),
              onPressed: () async {
                if (categoryEditingController.text.trim() == '') {
                  Fluttertoast.showToast(msg: "Description is empty!");
                  return;
                }
                Category category = categories.elementAt(i);
                category.description = categoryEditingController.text;
                await _save(category);
                editingTile = -1;
                setState(() {});
              }),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
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
