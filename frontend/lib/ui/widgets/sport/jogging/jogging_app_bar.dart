import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class JoggingAppBar extends StatelessWidget {
  final String activity;
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;

  const JoggingAppBar({
    Key? key,
    required this.activity,
    required this.onBackPressed,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left,
                size: 24,
              ),
            ),
          ),
          
          // Activity title with dropdown
          Row(
            children: [
              Icon(
                Icons.directions_run,
                color: orangeColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                activity,
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                color: blackColor,
                size: 20,
              ),
            ],
          ),
          
          // Menu button
          GestureDetector(
            onTap: onMenuPressed,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.more_horiz,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}