import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class TimerDisplay extends StatelessWidget {
  final String time;
  final String subtitle;
  
  const TimerDisplay({
    Key? key,
    required this.time,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            time,
            style: blackTextStyle.copyWith(
              fontSize: 48,
              fontWeight: extraBold,
              letterSpacing: 2.0,
            ),
          ),
          Text(
            subtitle,
            style: greyTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}