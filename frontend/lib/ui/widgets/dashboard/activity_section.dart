import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/dashboard/activity.dart';
import 'package:frontend/ui/pages/dashboard/sport/activity_page.dart'; // Import sport page

class ActivitySection extends StatelessWidget {
  final VoidCallback onSeeAllTapped;

  const ActivitySection({
    super.key,
    required this.onSeeAllTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activities recommendations',
                style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to SportPage when "see all" is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ActivityPage()),
                  );
                },
                child: Text(
                  'see all',
                  style: orangeTextStyle.copyWith(fontSize: 12, fontWeight: medium),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 98,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, idx) {
                final act = activities[idx];
                return Activity(assetPath: act.assetPath, label: act.label);
              },
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: activities.length),
        ),
        // Horizontal Scroll for Activity Cards
        const Padding(
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 5),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActivityCard(
                  title: 'Morning Jogging',
                  description:
                      'Get up early and get moving, it will make your day feel refreshing and cheerful',
                  badgeText: '+1 Point/Step',
                ),
                SizedBox(width: 16),
                ActivityCard(
                  title: 'Evening Yoga',
                  description:
                      "Relax your body and mind after a long day of activities. An easy way to stay healthy.",
                  badgeText: '+1 Point/Session',
                ),
                SizedBox(width: 16),
                ActivityCard(
                  title: 'Weekend Running',
                  description:
                      'Spend your weekend actively by running. Fresh air and exercise are the best combo!',
                  badgeText: '+2 Point/Event',
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}