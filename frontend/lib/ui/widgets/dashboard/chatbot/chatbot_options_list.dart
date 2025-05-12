import 'package:flutter/material.dart';
import 'package:frontend/ui/widgets/dashboard/chatbot/bot_option_button.dart';

class ChatbotOptionsList extends StatelessWidget {
  final Function(String, String) onOptionSelected;
  
  const ChatbotOptionsList({
    Key? key,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      children: [
        BotOptionButton(
          label: "Breakfast Recomendation",
          onTap: () {
            onOptionSelected(
              "Breakfast Recomendation", 
              'For breakfast, I recommend oatmeal with fruits and nuts or yogurt with granola. Both are nutritious options!'
            );
          },
        ),
        BotOptionButton(
          label: "Lunch Recomendation",
          onTap: () {
            onOptionSelected(
              "Lunch Recomendation", 
              'For lunch, try a balanced meal with protein, vegetables, and whole grains. A grilled chicken salad with quinoa is a great option!'
            );
          },
        ),
        BotOptionButton(
          label: "Morning Excercises",
          onTap: () {
            onOptionSelected(
              "Morning Excercises", 
              'Start your day with simple stretches, followed by a 10-minute cardio and 5-minute core workout. Great for boosting energy!'
            );
          },
        ),
        BotOptionButton(
          label: "Sleep Schedule",
          onTap: () {
            onOptionSelected(
              "Sleep Schedule", 
              'For better sleep, maintain a consistent schedule. Try to sleep and wake up at the same time daily, even on weekends.'
            );
          },
        ),
      ],
    );
  }
}