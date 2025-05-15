import 'package:flutter/material.dart';

class PrivacyPolicyText extends StatelessWidget {
  const PrivacyPolicyText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          color: Colors.black54,
          fontSize: 13,
          height: 1.5,
        ),
        children: [
          TextSpan(text: "By continuing you, you agree to the "),
          TextSpan(
            text: "Privacy Policy",
            style: TextStyle(
              color: Color(0xFFFF5722),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: " and "),
          TextSpan(
            text: "Terms of Use",
            style: TextStyle(
              color: Color(0xFFFF5722),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
