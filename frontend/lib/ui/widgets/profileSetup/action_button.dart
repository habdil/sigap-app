import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

enum ActionButtonType {
  enter,
  primary,
  secondary,
}

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ActionButtonType type;
  final bool isEnabled;
  final IconData? icon;
  
  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ActionButtonType.primary,
    this.isEnabled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ActionButtonType.enter:
        return SizedBox(
          height: 42,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: whiteColor,
              foregroundColor: blackColor,
              elevation: 0,
              disabledBackgroundColor: whiteColor.withOpacity(0.7),
              disabledForegroundColor: greyColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: isEnabled ? orangeColor : greyColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: medium,
                    color: isEnabled ? orangeColor : greyColor,
                  ),
                ),
                if (isEnabled) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: orangeColor,
                  ),
                ],
              ],
            ),
          ),
        );
      
      case ActionButtonType.primary:
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: isEnabled ? [
              BoxShadow(
                color: orangeColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ] : null,
          ),
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,
              foregroundColor: whiteColor,
              elevation: 0,
              disabledBackgroundColor: greyColor.withOpacity(0.2),
              disabledForegroundColor: greyColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: bold,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    icon,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        );
        
      case ActionButtonType.secondary:
        return Container(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: whiteColor,
              foregroundColor: orangeColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: orangeColor,
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: orangeTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: bold,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    icon,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        );
    }
  }
}