import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class AssessmentContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLastStep;

  const AssessmentContinueButton({
    Key? key,
    required this.onPressed,
    this.isEnabled = true,
    this.isLastStep = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          // Ubah warna menjadi oranye ketika tombol enabled (sudah memilih jawaban)
          backgroundColor: isEnabled ? orangeColor : Colors.grey.shade300,
          foregroundColor: isEnabled ? whiteColor : Colors.grey.shade600,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isLastStep ? 'Submit' : 'Continue',
          style: (isEnabled ? whiteTextStyle : greyTextStyle).copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
      ),
    );
  }
}