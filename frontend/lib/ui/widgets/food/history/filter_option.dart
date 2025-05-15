import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class FilterOption extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final bool isSmallScreen;
  final bool isPad;
  final Function(String) onChanged;

  const FilterOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.isSmallScreen,
    required this.isPad,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(
        title,
        style: blackTextStyle.copyWith(
          fontSize: isPad ? 16 : isSmallScreen ? 13 : 14,
        ),
      ),
      value: value,
      groupValue: groupValue,
      activeColor: orangeColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: isSmallScreen 
          ? const VisualDensity(horizontal: -4, vertical: -4) 
          : null,
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }
}