// lib\ui\widgets\food\nutrient_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class NutrientCard extends StatelessWidget {
  final String nutrientName;
  final String amount;
  final Color bgColor;
  final IconData iconData;
  final Color iconColor;
  final String perKg;

  const NutrientCard({
    Key? key,
    required this.nutrientName,
    required this.amount,
    required this.bgColor,
    required this.iconData,
    required this.iconColor,
    required this.perKg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nutrient name
          Padding(
            padding: const EdgeInsets.only(left: 58),
            child: Text(
              nutrientName,
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          const SizedBox(height: 8),
          // Icon and amount row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              // Amount
              Flexible(
                child: Text(
                  amount,
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Total/7day
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total/7day',
                      style: greyTextStyle.copyWith(
                        fontSize: 8,
                        fontWeight: medium,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'a day',
                      style: greyTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: light,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Bottom info
          Padding(
            padding: const EdgeInsets.only(left: 58),
            child: Text(
              perKg,
              style: greyTextStyle.copyWith(
                fontSize: 12,
                fontWeight: light,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}