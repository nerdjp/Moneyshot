import 'package:flutter/material.dart';
import 'package:moneyshot/page/categories_page.dart';
import 'package:moneyshot/page/spendings_page.dart';

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
  final _pageController = PageController();

  final List<Widget> _homePages = <Widget>[
    const CategoriesPage(),
    const SpendingsPage(),
    const Scaffold(),
  ];

  void _onItemTap(int index) {
    if (index < _homePages.length) {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(index);
      });
    }
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
        body: PageView(
          controller: _pageController,
          children: _homePages,
          onPageChanged: (page) {
            setState((){
              _selectedIndex = page;
            });
          },
        ),
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
