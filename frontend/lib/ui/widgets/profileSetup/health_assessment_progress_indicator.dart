import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class HealthAssessmentProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const HealthAssessmentProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep - 1;
          final isCompleted = index < currentStep - 1;
          
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive || isCompleted 
                    ? orangeColor 
                    : Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}