// lib\ui\widgets\food\avoid_food_category.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class AvoidFoodCategory extends StatelessWidget {
  final String iconPath;
  final String label;

  const AvoidFoodCategory({
    Key? key,
    required this.iconPath,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              iconPath,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: orangeTextStyle.copyWith(
              fontSize: 11, 
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}