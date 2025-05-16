import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class SettingsDialog extends StatelessWidget {
  final bool isGpsActive;
  final Function(bool) onGpsChanged;
  final Function(bool) onVoiceFeedbackChanged;

  const SettingsDialog({
    Key? key,
    required this.isGpsActive,
    required this.onGpsChanged,
    required this.onVoiceFeedbackChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Settings', style: blackTextStyle.copyWith(fontWeight: semiBold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text('GPS Tracking', style: blackTextStyle),
            value: isGpsActive,
            onChanged: (value) {
              Navigator.pop(context);
              onGpsChanged(value);
            },
          ),
          SwitchListTile(
            title: Text('Voice Feedback', style: blackTextStyle),
            value: true,
            onChanged: (value) {
              Navigator.pop(context);
              onVoiceFeedbackChanged(value);
            },
          ),
        ],
      ),
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
