import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class EmptyState extends StatelessWidget {
  final String searchQuery;
  final bool isPad;
  final VoidCallback onResetFilters;

  const EmptyState({
    Key? key,
    required this.searchQuery,
    required this.isPad,
    required this.onResetFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isPad ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isNotEmpty
                  ? Icons.search_off
                  : Icons.no_food,
              size: isPad ? 72 : 64,
              color: greyColor,
            ),
            SizedBox(height: isPad ? 24 : 16),
            Text(
              searchQuery.isNotEmpty
                  ? 'No results found'
                  : 'No food logs available',
              style: blackTextStyle.copyWith(
                fontSize: isPad ? 20 : 18,
                fontWeight: semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isPad ? 12 : 8),
            Text(
              searchQuery.isNotEmpty
                  ? 'Try a different search query or clear filters'
                  : 'Add your first food log from the Food page',
              style: greyTextStyle.copyWith(
                fontSize: isPad ? 16 : 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isPad ? 32 : 24),
            ElevatedButton(
              onPressed: () {
                if (searchQuery.isNotEmpty) {
                  onResetFilters();
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                foregroundColor: whiteColor,
                padding: EdgeInsets.symmetric(
                  horizontal: isPad ? 24 : 16,
                  vertical: isPad ? 12 : 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                searchQuery.isNotEmpty
                    ? 'Clear Filters'
                    : 'Back to Food Page',
                style: whiteTextStyle.copyWith(
                  fontSize: isPad ? 16 : 14,
                  fontWeight: medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}