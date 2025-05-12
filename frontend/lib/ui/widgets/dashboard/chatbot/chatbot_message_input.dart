import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ChatbotMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  
  const ChatbotMessageInput({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onAttachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: whiteColor,
            child: IconButton(
              icon: Icon(Icons.add, color: blackColor),
              onPressed: onAttachment,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSend(),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(0),
                    child: IconButton(
                      icon: Icon(Icons.send, color: blackColor),
                      onPressed: onSend,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}