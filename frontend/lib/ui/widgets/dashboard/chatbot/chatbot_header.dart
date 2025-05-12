import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ChatbotHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onMore;

  const ChatbotHeader({
    Key? key,
    required this.onBack,
    required this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: CircleAvatar(
              backgroundColor: whiteColor,
              child: Icon(Icons.arrow_back, color: blackColor),
            ),
          ),
          Text(
            "ChatBot",
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          CircleAvatar(
            backgroundColor: whiteColor,
            child: InkWell(
              onTap: onMore,
              child: Icon(Icons.more_horiz, color: blackColor),
            ),
          ),
        ],
      ),
    );
  }
}