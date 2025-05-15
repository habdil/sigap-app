import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class FoodSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final bool isPad;

  const FoodSearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.isPad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isPad ? 16 : 12),
      color: whiteColor,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search food logs...',
          hintStyle: greyTextStyle,
          prefixIcon: Icon(
            Icons.search,
            color: greyColor,
            size: isPad ? 24 : 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: isPad ? 16 : 12,
            horizontal: isPad ? 16 : 12,
          ),
          suffixIcon: searchQuery.isNotEmpty 
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: greyColor,
                    size: isPad ? 20 : 16,
                  ),
                  onPressed: () {
                    controller.clear();
                  },
                )
              : null,
        ),
        style: blackTextStyle.copyWith(
          fontSize: isPad ? 16 : 14,
        ),
      ),
    );
  }
}