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
  TextEditingController categoryEditingController = TextEditingController();

  ListTile makeCategoryListTile(
      BuildContext context, Category currentCategory) {
    return ListTile(
      title: Text(currentCategory.description),
      onLongPress: () {
        Fluttertoast.showToast(msg: "category: $currentCategory");
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) =>
                        CategoryEditPopup(category: currentCategory)).then((_) {
                  setState(() {});
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Icon(Icons.delete),
              onPressed: () {
                if (currentCategory.expenses.isNotEmpty) {
                  Fluttertoast.showToast(
                      msg: "You can only delete empty categories");
                  return;
                }
                showDialog(
                  context: context,
                  builder: (_) =>
                      CategoryDeletePopup(category: currentCategory),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: service.getCategories().isEmpty
          ? const Center(child: Text("No categories added"))
          : ListView.builder(
              itemCount: service.totalCategories(),
              itemBuilder: (context, i) {
                return makeCategoryListTile(
                    context, service.getCategories()[i]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (_) => CategoryEditPopup())
              .then((_) {
            setState(() {});
          });
        },
      ),
    );
  }
}

class CategoryEditPopup extends StatelessWidget {
  CategoryEditPopup({
    Key? key,
    Category? category,
  }) : super(key: key) {
    category == null ? _category = Category('') : _category = category;
  }

  late final Category _category;
  final TextEditingController _categoryDescription = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _categoryDescription.text = _category.description;
    _focusNode.requestFocus();
    return AlertDialog(
      title: Text(
          _category.description.isEmpty ? "Add Category" : "Edit Category"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _categoryDescription,
          focusNode: _focusNode,
          validator: (description) {
            if (description == null || description.isEmpty) {
              return 'Category description cannot be empty';
            }
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: _category.description.isEmpty
                ? "New Category"
                : _category.description,
          ),
        ),
      ),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _category.description = _categoryDescription.text;
              CategoriesService().save(_category);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}

class CategoryDeletePopup extends StatelessWidget {
  const CategoryDeletePopup({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${category.description}?"),
      actions: [
        TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context)),
        TextButton(
          child: const Text("Delete"),
          onPressed: () {
            CategoriesService().remove(category);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
