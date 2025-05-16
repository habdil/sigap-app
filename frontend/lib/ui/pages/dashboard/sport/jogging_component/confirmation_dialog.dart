import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

void showConfirmationDialog({
  required BuildContext context,
  required VoidCallback onEndActivity,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('End Activity', style: blackTextStyle.copyWith(fontWeight: semiBold)),
        content: Text(
          'Do you want to end your current jogging session?',
          style: blackTextStyle,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: greyTextStyle),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('End', style: orangeTextStyle),
            onPressed: () {
              Navigator.of(context).pop();
              onEndActivity();
            },
          ),
        ],
      );
    },
  );
}
