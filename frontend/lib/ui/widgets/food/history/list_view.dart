import 'package:flutter/material.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/ui/widgets/food/food_history_item.dart';

class FoodListView extends StatelessWidget {
  final List<FoodLog> filteredFoodLogs;
  final bool isPad;
  final Function(FoodLog) onFoodLogTap;

  const FoodListView({
    Key? key,
    required this.filteredFoodLogs,
    required this.isPad,
    required this.onFoodLogTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(isPad ? 16 : 12),
      itemCount: filteredFoodLogs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onFoodLogTap(filteredFoodLogs[index]),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FoodHistoryItem(foodLog: filteredFoodLogs[index]),
          ),
        );
      },
    );
  }
}