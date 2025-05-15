import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/activites/overview_activites/history_activity_item.dart';

/// History activities section with grid
class HistoryActivitiesSection extends StatelessWidget {
  const HistoryActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive grid
    final screenWidth = MediaQuery.of(context).size.width;
    final childAspectRatio = screenWidth < 360 ? 4.5 / 6 : 5 / 6;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HISTORY ACTIVITIES', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: screenWidth < 360 ? 14 : 16
          )
        ),
        const SizedBox(height: 12),
        GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HistoryActivityItem(
              day: 'YESTERDAY',
              activity: 'Running',
              distance: 4.5,
              duration: 45,
              title: 'Morning Routine',
              steps: 6028,
              bgColor: orangeColor,
            ),
            const HistoryActivityItem(
              day: 'FRIDAY',
              activity: 'Running',
              distance: 4.5,
              duration: 45,
              title: 'Morning Routine',
              steps: 6028,
              bgColor: Colors.white,
            ),
            const HistoryActivityItem(
              day: 'YESTERDAY',
              activity: 'YOGA',
              distance: 0,
              duration: 45,
              title: 'YOGA TIME...',
              steps: 6028,
              bgColor: Colors.white,
            ),
            HistoryActivityItem(
              day: 'YESTERDAY',
              activity: 'Running',
              distance: 4.5,
              duration: 45,
              title: 'Morning Routine',
              steps: 6028,
              bgColor: orangeColor,
            ),
          ],
        )
      ],
    );
  }
}