import 'package:flutter/material.dart';

enum ActionButtonType {
  enter,
  primary,
}

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ActionButtonType type;
  final bool isEnabled;
  
  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ActionButtonType.primary,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ActionButtonType.enter:
        return SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      
      case ActionButtonType.primary:
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFE8A3B),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }
}