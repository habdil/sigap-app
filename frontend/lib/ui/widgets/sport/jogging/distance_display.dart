import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class DistanceDisplay extends StatelessWidget {
  final String distance;
  
  const DistanceDisplay({
    Key? key,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          distance,
          style: blackTextStyle.copyWith(
            fontSize: 48,
            fontWeight: extraBold,
          ),
        ),
        Text(
          'Distance (km)',
          style: greyTextStyle.copyWith(
            fontSize: 14,
            fontWeight: medium,
          ),
        ),
      ],
    );
  }
}