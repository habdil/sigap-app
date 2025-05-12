import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class MedicalDisclaimerText extends StatelessWidget {
  const MedicalDisclaimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        '*This prediction does not replace a medical diagnosis.\nFor further examination, consult a doctor.',
        style: greyTextStyle.copyWith(
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}