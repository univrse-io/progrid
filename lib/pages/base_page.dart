import 'package:flutter/material.dart';
import 'package:progrid/pages/debug/home_page.dart';
import 'package:progrid/pages/debug/settings_page.dart';
import 'package:progrid/pages/debug/towers_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // keep track of current page
  int _currentPageIndex = 1;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    // add pages here
    _pages.add(const TowersPage());
    _pages.add(const HomePage());
    _pages.add(const SettingsPage());
  }

  // navigate pages
  void _navigatePages(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // prevent popping
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          // preload all pages
          index: _currentPageIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.secondary,
          currentIndex: _currentPageIndex,
          onTap: _navigatePages,
          iconSize: 28,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Towers"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
      ),
    );
  }
}
