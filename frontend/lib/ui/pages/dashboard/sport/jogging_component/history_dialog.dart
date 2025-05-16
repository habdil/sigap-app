import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class HistoryDialog extends StatelessWidget {
  const HistoryDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Activity History', style: blackTextStyle.copyWith(fontWeight: semiBold)),
      content: const Text('Your activity history will be shown here in the future.'),
      actions: <Widget>[
        TextButton(
          child: Text('Close', style: orangeTextStyle),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
