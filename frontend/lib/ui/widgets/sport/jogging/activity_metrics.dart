import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ActivityMetrics extends StatelessWidget {
  final String duration;
  final String pace;
  final String calories;

  const ActivityMetrics({
    Key? key,
    this.duration = '00:00',
    this.pace = '0.0/km',
    this.calories = '0',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Duration metric
          MetricItem(
            icon: 'assets/sport_jogging/ic_stopwatch.png',
            value: duration,
            label: 'Duration',
            fallbackIcon: Icons.timer,
          ),
          
          // Pace metric
          MetricItem(
            icon: 'assets/sport_jogging/ic_run.png',
            value: pace,
            label: 'Avg pace',
            fallbackIcon: Icons.directions_run,
          ),
          
          // Calories metric
          MetricItem(
            icon: 'assets/sport_jogging/ic_calori.png',
            value: '$calories kcal',
            label: 'Calories',
            fallbackIcon: Icons.local_fire_department,
          ),
        ],
      ),
    );
  }
}

class MetricItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final IconData fallbackIcon;

  const MetricItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.fallbackIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Use Image.asset with errorBuilder to handle missing assets
          Image.asset(
            icon,
            width: 24,
            height: 24,
            color: blackColor,
            errorBuilder: (context, error, stackTrace) {
              // Fallback icon if asset fails to load
              return Icon(
                fallbackIcon,
                size: 24,
                color: blackColor,
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          Text(
            label,
            style: greyTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}