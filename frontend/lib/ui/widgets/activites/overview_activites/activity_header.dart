import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

/// Header component with user profile and points
class ActivityHeader extends StatelessWidget {
  const ActivityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: blueColor.withOpacity(0.2),
              child: Image.asset('assets/icn_user.png', height: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'User',
                  style: blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      '10,206',
                      style: orangeTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
                    ),
                    Text(
                      ' SIGAP Points',
                      style: blackTextStyle.copyWith(fontWeight: medium, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.menu, color: blackColor),
          onPressed: () {},
        ),
      ],
    );
  }
}