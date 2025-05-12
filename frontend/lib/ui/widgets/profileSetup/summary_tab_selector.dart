import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

enum SummaryTabType {
  donts,
  personal,
  doS,
}

class SummaryTabSelector extends StatelessWidget {
  final SummaryTabType selectedTab;
  final Function(SummaryTabType) onTabChanged;

  const SummaryTabSelector({
    Key? key,
    required this.selectedTab,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem(
            title: "Don't's",
            type: SummaryTabType.donts,
          ),
          _buildTabItem(
            title: "Personal",
            type: SummaryTabType.personal,
          ),
          _buildTabItem(
            title: "Do",
            type: SummaryTabType.doS,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required SummaryTabType type,
  }) {
    final isSelected = selectedTab == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(type),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? orangeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? whiteColor : blackColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}