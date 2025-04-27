import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _iconPaths = [
    'assets/icn_home.png',
    'assets/icn_run.png',
    'assets/icn_eat.png',
    'assets/icn_user.png',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: List.generate(
        _iconPaths.length,
        (index) => _buildNavItem(_iconPaths[index], index),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            iconPath,
            width: 28,
            height: 28,
            color: Colors.black, // semua icon awal hitam
          ),
          if (_selectedIndex == index)
            Positioned(
              bottom: -2,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      label: '',
    );
  }
}
