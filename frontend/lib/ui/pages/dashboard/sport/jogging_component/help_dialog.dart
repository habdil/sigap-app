import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Help', style: blackTextStyle.copyWith(fontWeight: semiBold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How to use Running Tracker:', style: blackTextStyle.copyWith(fontWeight: medium)),
          const SizedBox(height: 8),
          Text('• Press the PLAY button to start tracking', style: blackTextStyle),
          Text('• Press the PAUSE button to pause', style: blackTextStyle),
          Text('• Press the STOP button to end activity', style: blackTextStyle),
          Text('• Press the FLAG button to mark a lap', style: blackTextStyle),
          const SizedBox(height: 8),
          Text('Earn coins based on your activity duration!', style: orangeTextStyle),
          Text('• Jogging: 0.4 coins per minute', style: blackTextStyle),
          Text('• Extra bonuses for longer sessions', style: blackTextStyle),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Got it', style: orangeTextStyle),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
