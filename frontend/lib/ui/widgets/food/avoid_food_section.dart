// lib\ui\widgets\food\avoid_food_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/food/avoid_food_category.dart';

class AvoidFoodSection extends StatelessWidget {
  const AvoidFoodSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Want To Avoid',
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          // Food to avoid categories
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                AvoidFoodCategory(iconPath: 'assets/ic_junkfood.png', label: 'Junk Food'),
                SizedBox(width: 16),
                AvoidFoodCategory(iconPath: 'assets/ic_peanut.png', label: 'Peanut'),
                SizedBox(width: 16),
                AvoidFoodCategory(iconPath: 'assets/ic_meat.png', label: 'High Calories'),
                SizedBox(width: 16),
                AvoidFoodCategory(iconPath: 'assets/ic_spicy.png', label: 'Spicy Food'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}