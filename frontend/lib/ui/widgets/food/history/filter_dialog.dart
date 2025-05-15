import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'sort_option.dart';
import 'sort_direction_option.dart';
import 'filter_option.dart';

class FilterDialog extends StatefulWidget {
  final String initialSortBy;
  final bool initialSortAscending;
  final String initialFilterBy;
  final Function(String, bool, String) onApplyFilters;

  const FilterDialog({
    super.key,
    required this.initialSortBy,
    required this.initialSortAscending,
    required this.initialFilterBy,
    required this.onApplyFilters,
  });

  static Future<void> show(
    BuildContext context,
    String sortBy,
    bool sortAscending,
    String filterBy,
    Function(String, bool, String) onApplyFilters,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => FilterDialog(
        initialSortBy: sortBy,
        initialSortAscending: sortAscending,
        initialFilterBy: filterBy,
        onApplyFilters: onApplyFilters,
      ),
    );
  }

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String _tempSortBy;
  late bool _tempSortAscending;
  late String _tempFilterBy;

  @override
  void initState() {
    super.initState();
    _tempSortBy = widget.initialSortBy;
    _tempSortAscending = widget.initialSortAscending;
    _tempFilterBy = widget.initialFilterBy;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive dialog
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    
    // Adaptive sizing based on screen width
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final isPad = screenWidth >= 600;
    
    // Adaptive dialog width
    final dialogWidth = isPad 
        ? screenWidth * 0.5 // 50% of screen width for tablets
        : isMediumScreen 
            ? screenWidth * 0.85 // 85% of screen width for medium phones
            : screenWidth * 0.9; // 90% of screen width for small phones
    
    // Adaptive text sizes
    final titleSize = isPad ? 20.0 : isMediumScreen ? 18.0 : 16.0;
    final sectionTitleSize = isPad ? 16.0 : isMediumScreen ? 14.0 : 13.0;
    final contentPadding = isPad ? 24.0 : isMediumScreen ? 20.0 : 16.0;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: dialogWidth,
          padding: EdgeInsets.all(contentPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Food Logs',
                style: blackTextStyle.copyWith(
                  fontSize: titleSize,
                  fontWeight: semiBold,
                ),
              ),
              SizedBox(height: isPad ? 24 : 16),
              
              // Sort by section
              Text(
                'Sort By',
                style: blackTextStyle.copyWith(
                  fontSize: sectionTitleSize,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 8),
              SortOption(
                title: 'Date',
                value: 'date',
                groupValue: _tempSortBy,
                isSmallScreen: isSmallScreen,
                isPad: isPad,
                onChanged: (value) {
                  setState(() {
                    _tempSortBy = value;
                  });
                },
              ),
              SortOption(
                title: 'Name',
                value: 'name',
                groupValue: _tempSortBy,
                isSmallScreen: isSmallScreen,
                isPad: isPad,
                onChanged: (value) {
                  setState(() {
                    _tempSortBy = value;
                  });
                },
              ),
              SortOption(
                title: 'Calories',
                value: 'calories',
                groupValue: _tempSortBy,
                isSmallScreen: isSmallScreen,
                isPad: isPad,
                onChanged: (value) {
                  setState(() {
                    _tempSortBy = value;
                  });
                },
              ),
              
              // Sort direction
              SizedBox(height: 16),
              SortDirectionOption(
                isAscending: _tempSortAscending,
                isSmallScreen: isSmallScreen,
                isPad: isPad,
                onChanged: (value) {
                  setState(() {
                    _tempSortAscending = value;
                  });
                },
              ),
              
              // Filter by section
              SizedBox(height: isPad ? 24 : 16),
              Text(
                'Filter By',
                style: blackTextStyle.copyWith(
                  fontSize: sectionTitleSize,
                  fontWeight: medium,
                ),
              ),
              SizedBox(height: 8),
              FilterOption(
                title: 'All Logs',
                value: 'all',
                groupValue: _tempFilterBy,
                isSmallScreen: isSmallScreen,
                isPad: isPad,
                onChanged: (value) {
                  setState(() {
                    _tempFilterBy = value;
                  });
                },
              ),
              FilterOption(
                title: 'Analyzed Only',
                value: 'analyzed',
                groupValue: _tempFilterBy,
                isSmallScreen: isSmallScreen,
                isPad: isPad,
                onChanged: (value) {
                  setState(() {
                    _tempFilterBy = value;
                  });
                },
              ),
              FilterOption(
                title: 'Not Analyzed',
                value: 'not_analyzed',
                groupValue: _tempFilterBy,
                isSmallScreen: isSmallScreen,
                isPad: isPad,
                onChanged: (value) {
                  setState(() {
                    _tempFilterBy = value;
                  });
                },
              ),
              
              // Buttons
              SizedBox(height: isPad ? 32 : 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Reset button
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _tempSortBy = 'date';
                        _tempSortAscending = false;
                        _tempFilterBy = 'all';
                      });
                    },
                    child: Text(
                      'Reset',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: isPad ? 16 : isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                  SizedBox(width: isPad ? 16 : 8),
                  // Apply button
                  ElevatedButton(
                    onPressed: () {
                      // Apply filters and close dialog
                      widget.onApplyFilters(
                        _tempSortBy,
                        _tempSortAscending,
                        _tempFilterBy,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orangeColor,
                      foregroundColor: whiteColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: isPad ? 24 : isSmallScreen ? 12 : 16,
                        vertical: isPad ? 12 : isSmallScreen ? 6 : 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: whiteTextStyle.copyWith(
                        fontSize: isPad ? 16 : isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}