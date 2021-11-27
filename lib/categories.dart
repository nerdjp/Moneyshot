import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'spendings.dart';
import 'data.dart';
import 'database_helper.dart';

class Category extends Data {
	static List<Category> categories = <Category>[];
	static String categoryTable = 'categories';
	List<Spendings> spendings = <Spendings>[];
	String description;
	Category(this.description) {
		table = categoryTable;
		categories.add(this);
		DatabaseHelper.instance.create(this);
	}
	Category.withId(int idIn, this.description) {
		table = categoryTable;
		id = idIn;
	}

	static void createCategory(String description) async {
		Category temp = Category(description);
		temp.id = await DatabaseHelper.instance.createCategory(temp);
	}

	static void removeCategory(Category category) async {
		DatabaseHelper.instance.removeCategory(category.id);
		categories.remove(category);
	}

	static void editCategory(Category category, String newDescription) async {
		DatabaseHelper.instance.updateCategory(category);
		category.description = newDescription;
	}

	addSpending(DateTime date, String desc, double value, DateTime? paymentDate, int? installments, int? totalInstallments) {
		spendings.add(Spendings(date, desc, value, this, paymentDate, installments, totalInstallments));
	}

	static Future initCategories() async {
		final dbCategories = await DatabaseHelper.instance.read(categoryTable);

		if(dbCategories.isEmpty) return;

		for (int i = 0; i < dbCategories.length; i++) {
			final categoryInfo = dbCategories.elementAt(i);
			print(categoryInfo.toString());
			categories.add(
				Category.withId(
					categoryInfo['id'] as int, categoryInfo['description'] as String
				)
			);
		}
	}
	
	@override
	Map<String, Object?> toJson() => {
		'id': id,
		'description': description,
	};
}

class CategoriesPage extends StatefulWidget {
	const CategoriesPage({Key? key}) : super(key: key);
	@override
	_CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
	int editingTile = -1;
	TextEditingController categoryEditingController = TextEditingController();

	ListTile makeCategoryListTile(int i) {
		return ListTile(
			title: Text(Category.categories[i].description),
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
								Category currentCategory = Category.categories.elementAt(i);
								if(currentCategory.spendings.isEmpty) {
									setState(() {
										Category.removeCategory(currentCategory);
									});
									SnackBar snackBar = SnackBar(
										content: Text("Category ${currentCategory.description.toString()} deleted."),
										action: SnackBarAction(
											label: 'Undo',
											onPressed: () {
												setState(() {
													Category.categories.add(currentCategory);
												});
											},
										),
									);
									ScaffoldMessenger.of(context).showSnackBar(snackBar);
								} else {
									Fluttertoast.showToast(msg: "You can only delete empty categories");
								}
							},
						),
					),
				],
			),
		);
	}

	ListTile makeEditableCategoryListTile(int i) {
		Category currentCategory = Category.categories.elementAt(i);
		categoryEditingController.text = currentCategory.description;
		return ListTile(
			title: TextField(
				controller: categoryEditingController,
				decoration: InputDecoration(
					hintText: currentCategory.description,
					border: const OutlineInputBorder(),
				),
			),
			trailing: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Padding(
						padding: const EdgeInsets.all(8.0),
						child: TextButton(
							child: const Icon(Icons.cancel),
							onPressed: () {
							categoryEditingController.clear();
								setState(() {
									editingTile = -1;
								});
							}
						),
					),
					Padding(
						padding: const EdgeInsets.all(8.0),
						child: TextButton(
							child: const Icon(Icons.check),
							onPressed: () {
								Category.editCategory(currentCategory, categoryEditingController.text);
								setState(() {
									editingTile = -1;
								});
							}
						),
					),
				]
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		//fillCategories();
		return Scaffold(
			body: ListView.builder(
				itemCount: Category.categories.length,
				itemBuilder: (context, i) {
					if (i == editingTile) {
						return makeEditableCategoryListTile(i);
					} else {
						return makeCategoryListTile(i);
					}
				}
			),
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.add),
				onPressed: () {
					setState(() {
						Category.createCategory("New Category");
					});
				},
			)
		);
	}
}

