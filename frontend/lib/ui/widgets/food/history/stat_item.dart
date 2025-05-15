import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isPad;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isPad,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isPad ? 12 : 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: isPad ? 24 : 20,
          ),
        ),
        SizedBox(height: isPad ? 8 : 4),
        Text(
          value,
          style: blackTextStyle.copyWith(
            fontSize: isPad ? 18 : 16,
            fontWeight: semiBold,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: greyTextStyle.copyWith(
            fontSize: isPad ? 14 : 12,
          ),
        ),
      ],
    );
  }
}