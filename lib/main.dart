import 'package:flutter/material.dart';
import 'package:moneyshot/page/categories_page.dart';

import 'entity/category.dart';
import 'entity/spendings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MoneyShot());
}

class MoneyShot extends StatefulWidget {
  const MoneyShot({Key? key}) : super(key: key);

  @override
  State<MoneyShot> createState() => _MoneyShotState();
}

class _MoneyShotState extends State<MoneyShot> {
  int _selectedIndex = 0;
  final textController = TextEditingController();

  final List<Widget> _homePages = <Widget>[
    const CategoriesPage(),
    //const SpendingsPage(),
    const Scaffold(),
  ];

  void _onItemTap(int index) {
    if (index < _homePages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _editText(String text) {
    setState(() {
      //_selectedText = text;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyShot',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("MoneyShot"),
        ),
        body: _homePages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Categories"),
            BottomNavigationBarItem(icon: Icon(Icons.paid), label: "Spendings"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Compare"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
      ),
    );
  }
}
