import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/pages/dashboard/dashboard_page.dart';
import 'package:frontend/ui/pages/dashboard/food/food_page.dart';
import 'package:frontend/ui/pages/dashboard/profile/profile_page.dart';
import 'package:frontend/ui/pages/dashboard/sport/sport_page.dart';

class CustomNavBar extends StatefulWidget {
  final int initialIndex;

  const CustomNavBar({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Menggunakan Navigator.pushAndRemoveUntil untuk menghapus histori navigasi
    Widget page;
    switch (index) {
      case 0:
        page = const DashboardPage();
        break;
      case 1:
        page = const SportPage();
        break;
      case 2:
        page = const FoodPage();
        break;
      case 3:
        page = const ProfilePage();
        break;
      default:
        page = const DashboardPage();
    }

    // Menggunakan PageRouteBuilder dengan transisi kosong untuk menghilangkan efek pop
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/icn_home_active.png'),
          _buildNavItem(1, 'assets/icn_run.png'),
          _buildNavItem(2, 'assets/icn_eat.png'),
          _buildNavItem(3, 'assets/icn_user.png'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected ? orangeColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 24,
                height: 24,
                color: isSelected ? orangeColor : greyColor,
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}