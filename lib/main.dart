import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moneyshot/page/categories_page.dart';
import 'package:moneyshot/page/expenses_page.dart';
import 'package:moneyshot/page/planning_page.dart';
import 'package:moneyshot/service/categories_service.dart';
import 'package:moneyshot/service/expenses_service.dart';

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
  bool _isLoaded = false;

  Future<void> loadData() async {
    await CategoriesService().init();
    await ExpensesService().init();
  }

  @override
  void initState() {
    loadData().then((_) {
      setState(() {
        _isLoaded = true;
      });
    });
    super.initState();
  }

  final List<Widget> _pages = <Widget>[
    const CategoriesPage(),
    const ExpensesPage(),
    const PlanningPage(),
  ];

  void _onItemTap(int index) {
    if (index < _pages.length) {
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: !_isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                title: const Text("MoneyShot"),
              ),
              body: PageView(
                controller: _pageController,
                children: _pages,
                onPageChanged: (page) {
                  setState(() {
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
                  BottomNavigationBarItem(
                      icon: Icon(Icons.paid), label: "Spendings"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: "Compare"),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTap,
              ),
            ),
    );
  }
}
