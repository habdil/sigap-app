import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class BotOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const BotOptionButton({
    super.key, 
    required this.label, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: whiteColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}