// lib/ui/widgets/food/scan_food/result_scan/nutrient_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class NutrientCard extends StatelessWidget {
  final String title;
  final String amount;
  final String perKg;
  final Color? backgroundColor;
  
  const NutrientCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.perKg,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nutrient icon and name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getNutrientIcon(title),
              const SizedBox(width: 8),
              Text(
                title,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Amount
          Text(
            amount,
            style: blackTextStyle.copyWith(
              fontSize: 28,
              fontWeight: bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Per kg
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getAccentColor(title).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              perKg,
              style: blackTextStyle.copyWith(
                color: _getAccentColor(title),
                fontSize: 12,
                fontWeight: medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get appropriate icon for each nutrient
  Widget _getNutrientIcon(String nutrientName) {
    IconData iconData;
    Color iconColor = _getAccentColor(nutrientName);
    
    switch (nutrientName.toLowerCase()) {
      case 'protein':
        iconData = Icons.fitness_center;
        break;
      case 'carbs':
        iconData = Icons.grain;
        break;
      case 'fat':
        iconData = Icons.opacity;
        break;
      case 'fibers':
        iconData = Icons.grass;
        break;
      case 'calories':
        iconData = Icons.local_fire_department;
        break;
      default:
        iconData = Icons.circle;
        iconColor = orangeColor;
    }
    
    return Icon(
      iconData,
      color: iconColor,
      size: 18,
    );
  }
  
  // Helper method to get accent color for each nutrient type
  Color _getAccentColor(String nutrientName) {
    switch (nutrientName.toLowerCase()) {
      case 'protein':
        return Colors.orange;
      case 'carbs':
        return Colors.amber.shade700;
      case 'fat':
        return Colors.blue;
      case 'fibers':
        return Colors.green;
      case 'calories':
        return Colors.red;
      default:
        return orangeColor;
    }
  }
}