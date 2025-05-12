import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class AssessmentQuestionHeader extends StatelessWidget {
  final String question;
  final String description;

  const AssessmentQuestionHeader({
    Key? key,
    required this.question,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: blackTextStyle.copyWith(
              fontSize: 24,
              fontWeight: black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: greyTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}