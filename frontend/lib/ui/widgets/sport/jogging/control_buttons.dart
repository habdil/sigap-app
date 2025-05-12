import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final VoidCallback onFlag;
  final bool isRunning;
  final bool isPaused;

  const ControlButtons({
    Key? key,
    required this.onStart,
    required this.onPause,
    required this.onStop,
    required this.onFlag,
    this.isRunning = false,
    this.isPaused = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to make buttons responsive
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate button sizes based on screen width
    final smallButtonSize = screenWidth * 0.13; // 13% of screen width
    final largeButtonSize = screenWidth * 0.17; // 17% of screen width
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stop button
          GestureDetector(
            onTap: onStop,
            child: Container(
              width: smallButtonSize,
              height: smallButtonSize,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.stop,
                size: smallButtonSize * 0.4, // 40% of button size
              ),
            ),
          ),
          
          SizedBox(width: screenWidth * 0.05), // 5% of screen width
          
          // Start/Pause button
          GestureDetector(
            onTap: isRunning ? onPause : onStart,
            child: Container(
              width: largeButtonSize,
              height: largeButtonSize,
              decoration: BoxDecoration(
                color: orangeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRunning ? Icons.pause : Icons.play_arrow,
                color: whiteColor,
                size: largeButtonSize * 0.45, // 45% of button size
              ),
            ),
          ),
          
          SizedBox(width: screenWidth * 0.05), // 5% of screen width
          
          // Flag button
          GestureDetector(
            onTap: onFlag,
            child: Container(
              width: smallButtonSize,
              height: smallButtonSize,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flag,
                size: smallButtonSize * 0.4, // 40% of button size
              ),
            ),
          ),
        ],
      ),
    );
  }
}