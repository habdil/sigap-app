import 'package:flutter/material.dart';
import 'package:frontend/ui/pages/dashboard_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    // ActivityPage(),
    // FoodPage(),
    // ProfilePage(),
  ];

  final List<String> _iconPaths = [
    'assets/icn_home_active.png',
    'assets/icn_run.png',
    'assets/icn_eat.png',
    'assets/icn_user.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: List.generate(_iconPaths.length, (index) {
          return BottomNavigationBarItem(
            icon: Image.asset(
              _iconPaths[index],
              width: 28,
              height: 28,
              color: _currentIndex == index ? Colors.orange : Colors.black54,
            ),
            label: '',
          );
        }),
      ),
    );
  }
}
