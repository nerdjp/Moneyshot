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
  int editingIndex = -1;
  TextEditingController categoryEditingController = TextEditingController();
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    service.getAll().then((value) {
      setState(() {
        categories = value;
		currentCategory = categories.first;
	  });
	});
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  void _save(Category category)  {
    service.save(category);
  }

  void _delete(Category category)  {
    service.remove(category).then((value) {
		setState((){
			categories.remove(category);
		});
	});
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
				if(currentCategory.spendings.isEmpty) {
				  Fluttertoast.showToast(msg: "You can only delete empty categories");
				  return;
				}
                setState(() {
                  _delete(currentCategory);
				});
                SnackBar snackBar = SnackBar(
                  content: Text("Category ${currentCategory.description.toString()} deleted."),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () async {
                      setState(() {
				  	    _save(currentCategory);
						categories.add(currentCategory);
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

  ListTile makeEditableCategoryListTile() {
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
					categories.remove(currentCategory);
					editingIndex = -1;
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
              _save(currentCategory);
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
          itemCount: categories.length,
          itemBuilder: (context, i) {
            if (i == editingIndex) {
              return makeEditableCategoryListTile();
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
            editingIndex = categories.length - 1;
            myFocusNode.requestFocus();
          });
        },
      ),
    );
  }
}
