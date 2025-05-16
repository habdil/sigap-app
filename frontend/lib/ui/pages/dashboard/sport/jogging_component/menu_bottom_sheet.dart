import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

void showMenuBottomSheet({
  required BuildContext context,
  required bool isRunning,
  required bool isPaused,
  required VoidCallback onSettingsTap,
  required VoidCallback onHistoryTap,
  required VoidCallback onHelpTap,
  required VoidCallback onEndActivityTap,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.settings, color: blackColor),
            title: Text('Settings', style: blackTextStyle),
            onTap: () {
              Navigator.pop(context);
              onSettingsTap();
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: blackColor),
            title: Text('Activity History', style: blackTextStyle),
            onTap: () {
              Navigator.pop(context);
              onHistoryTap();
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: blackColor),
            title: Text('Help', style: blackTextStyle),
            onTap: () {
              Navigator.pop(context);
              onHelpTap();
            },
          ),
          if (isRunning || isPaused)
            ListTile(
              leading: Icon(Icons.stop_circle, color: Colors.red),
              title: Text('End Activity', style: blackTextStyle),
              onTap: () {
                Navigator.pop(context);
                onEndActivityTap();
              },
            ),
        ],
      ),
    ),
  );
}
