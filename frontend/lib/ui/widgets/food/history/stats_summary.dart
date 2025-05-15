import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/models/food_model.dart';
import 'stat_item.dart';

class StatsSummary extends StatelessWidget {
  final List<FoodLog> allFoodLogs;
  final bool isPad;

  const StatsSummary({
    super.key,
    required this.allFoodLogs,
    required this.isPad,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final totalLogs = allFoodLogs.length;
    final analyzedLogs = allFoodLogs.where((log) => log.analysis != null).length;
    final totalCalories = allFoodLogs
        .where((log) => log.analysis != null)
        .fold<int>(0, (sum, log) => sum + (log.analysis?.calories ?? 0));
    final avgCalories = analyzedLogs > 0 
        ? (totalCalories / analyzedLogs).round() 
        : 0;
    
    return Container(
      padding: EdgeInsets.all(isPad ? 16 : 12),
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: blackTextStyle.copyWith(
              fontSize: isPad ? 16 : 14,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(height: isPad ? 12 : 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatItem(
                label: 'Total Logs',
                value: totalLogs.toString(),
                icon: Icons.restaurant,
                color: orangeColor,
                isPad: isPad,
              ),
              StatItem(
                label: 'Analyzed',
                value: analyzedLogs.toString(),
                icon: Icons.check_circle,
                color: blueColor,
                isPad: isPad,
              ),
              StatItem(
                label: 'Avg Calories',
                value: '$avgCalories kcal',
                icon: Icons.local_fire_department,
                color: Colors.red,
                isPad: isPad,
              ),
            ],
          ),
        ],
      ),
    );
  }
}