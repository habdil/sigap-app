import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ChatbotWelcomeMessage extends StatelessWidget {
  const ChatbotWelcomeMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Hello, User",
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: blackColor.withOpacity(0.6),
          ),
        ),
        Text(
          "How can I help you\ntoday?",
          textAlign: TextAlign.center,
          style: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: blackColor.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 10),
        Theme(
          data: Theme.of(context).copyWith(
            chipTheme: ChipThemeData(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          child: Chip(
            label: Text(
              "Powered By Gemini",
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: blackColor.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}