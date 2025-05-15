// frontend/lib/ui/widgets/dashboard/profile/menu_icons_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class MenuIconsSection extends StatelessWidget {
  const MenuIconsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconMenu('10 recipes', 'assets/icn_eat.png'),
          _buildVerticalDivider(),
          _buildIconMenu('4km run\na week', 'assets/icn_run.png'),
          _buildVerticalDivider(),
          _buildIconMenu('Post Goal', Icons.post_add),
        ],
      ),
    );
  }

  Widget _buildIconMenu(String text, dynamic icon) {
    return Column(
      children: [
        icon is IconData
            ? Icon(
                icon,
                color: orangeColor,
                size: 24,
              )
            : Image.asset(
                icon,
                width: 24,
                height: 24,
              ),
        const SizedBox(height: 8),
        Text(
          text,
          style: blackTextStyle.copyWith(
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}