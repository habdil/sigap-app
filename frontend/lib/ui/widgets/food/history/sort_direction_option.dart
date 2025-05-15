import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class SortDirectionOption extends StatelessWidget {
  final bool isAscending;
  final bool isSmallScreen;
  final bool isPad;
  final Function(bool) onChanged;

  const SortDirectionOption({
    super.key,
    required this.isAscending,
    required this.isSmallScreen,
    required this.isPad,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // For small screens, use a vertical layout
    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order:',
            style: blackTextStyle.copyWith(
              fontSize: isPad ? 16 : 13,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text(
                  'Newest First',
                  style: TextStyle(
                    color: !isAscending ? whiteColor : blackColor,
                    fontSize: isPad ? 14 : 12,
                  ),
                ),
                selected: !isAscending,
                selectedColor: orangeColor,
                backgroundColor: Colors.grey.shade200,
                onSelected: (selected) {
                  if (selected) {
                    onChanged(false);
                  }
                },
              ),
              ChoiceChip(
                label: Text(
                  'Oldest First',
                  style: TextStyle(
                    color: isAscending ? whiteColor : blackColor,
                    fontSize: isPad ? 14 : 12,
                  ),
                ),
                selected: isAscending,
                selectedColor: orangeColor,
                backgroundColor: Colors.grey.shade200,
                onSelected: (selected) {
                  if (selected) {
                    onChanged(true);
                  }
                },
              ),
            ],
          ),
        ],
      );
    }
    
    // For medium and large screens, use a horizontal layout
    return Row(
      children: [
        Text(
          'Order:',
          style: blackTextStyle.copyWith(
            fontSize: isPad ? 16 : 14,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text(
                  'Newest First',
                  style: TextStyle(
                    color: !isAscending ? whiteColor : blackColor,
                    fontSize: isPad ? 14 : 12,
                  ),
                ),
                selected: !isAscending,
                selectedColor: orangeColor,
                backgroundColor: Colors.grey.shade200,
                onSelected: (selected) {
                  if (selected) {
                    onChanged(false);
                  }
                },
              ),
              ChoiceChip(
                label: Text(
                  'Oldest First',
                  style: TextStyle(
                    color: isAscending ? whiteColor : blackColor,
                    fontSize: isPad ? 14 : 12,
                  ),
                ),
                selected: isAscending,
                selectedColor: orangeColor,
                backgroundColor: Colors.grey.shade200,
                onSelected: (selected) {
                  if (selected) {
                    onChanged(true);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}