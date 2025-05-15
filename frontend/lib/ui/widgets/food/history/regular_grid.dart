import 'package:flutter/material.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/ui/widgets/food/food_history_item.dart';

class RegularGrid extends StatelessWidget {
  final List<FoodLog> filteredFoodLogs;
  final bool isPad;
  final Function(FoodLog) onFoodLogTap;

  const RegularGrid({
    Key? key,
    required this.filteredFoodLogs,
    required this.isPad,
    required this.onFoodLogTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(isPad ? 16 : 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredFoodLogs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onFoodLogTap(filteredFoodLogs[index]),
          child: FoodHistoryItem(foodLog: filteredFoodLogs[index]),
        );
      },
    );
  }
}