import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/models/food_model.dart';
import 'package:frontend/ui/widgets/food/food_history_item.dart';
import 'empty_state.dart';
import 'wide_grid.dart';
import 'regular_grid.dart';
import 'list_view.dart';

class FoodLogsList extends StatelessWidget {
  final List<FoodLog> filteredFoodLogs;
  final List<FoodLog> allFoodLogs;
  final String searchQuery;
  final String filterBy;
  final bool isPad;
  final Function(FoodLog) onFoodLogTap;
  final VoidCallback onResetFilters;

  const FoodLogsList({
    Key? key,
    required this.filteredFoodLogs,
    required this.allFoodLogs,
    required this.searchQuery,
    required this.filterBy,
    required this.isPad,
    required this.onFoodLogTap,
    required this.onResetFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (filteredFoodLogs.isEmpty) {
      return EmptyState(
        searchQuery: searchQuery,
        isPad: isPad,
        onResetFilters: onResetFilters,
      );
    }
    
    // Determine if we should use grid layout
    final isWideScreen = MediaQuery.of(context).size.width > 900;
    final isGrid = isPad && !isWideScreen;
    final isWideGrid = isPad && isWideScreen;
    
    // Show results count and applied filters
    return Column(
      children: [
        // Results header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isPad ? 16 : 12,
            vertical: isPad ? 12 : 8,
          ),
          color: whiteColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Found ${filteredFoodLogs.length} ${filteredFoodLogs.length == 1 ? 'result' : 'results'}',
                style: blackTextStyle.copyWith(
                  fontSize: isPad ? 14 : 12,
                ),
              ),
              // Reset filters
              if (searchQuery.isNotEmpty || filterBy != 'all')
                GestureDetector(
                  onTap: onResetFilters,
                  child: Text(
                    'Reset Filters',
                    style: orangeTextStyle.copyWith(
                      fontSize: isPad ? 14 : 12,
                      fontWeight: medium,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Divider
        Container(
          height: 1,
          color: Colors.grey.shade200,
        ),
        // List or grid
        Expanded(
          child: isWideGrid 
            ? WideGrid(
                filteredFoodLogs: filteredFoodLogs,
                isPad: isPad,
                onFoodLogTap: onFoodLogTap,
              )
            : isGrid 
              ? RegularGrid(
                  filteredFoodLogs: filteredFoodLogs,
                  isPad: isPad,
                  onFoodLogTap: onFoodLogTap,
                )
              : FoodListView(
                  filteredFoodLogs: filteredFoodLogs,
                  isPad: isPad,
                  onFoodLogTap: onFoodLogTap,
                ),
        ),
      ],
    );
  }
}