import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

final List<_Activity> activities = [
  _Activity(assetPath: 'assets/ic_yoga.png', label: 'Yoga'),
  _Activity(assetPath: 'assets/ic_badminton.png', label: 'Badminton'),
  _Activity(assetPath: 'assets/ic_jogging.png', label: 'Jogging'),
  _Activity(assetPath: 'assets/ic_running.png', label: 'Running'),
  _Activity(assetPath: 'assets/ic_yoga.png', label: 'Yoga'),
  _Activity(assetPath: 'assets/ic_badminton.png', label: 'Badminton'),
  // dst...
];

class _Activity {
  final String assetPath;
  final String label;
  _Activity({required this.assetPath, required this.label});
}

class Activity extends StatelessWidget {
  final String assetPath;
  final String label;
  const Activity({super.key, required this.assetPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            width: 36,
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: orangeTextStyle.copyWith(fontSize: 12, fontWeight: medium),
          ),
        ],
      ),
    );
  }
}

// activity for card
class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String badgeText;

  const ActivityCard({
    Key? key,
    required this.title,
    required this.description,
    required this.badgeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        description,
                        style: greyTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Badge
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                badgeText,
                style: whiteTextStyle.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}