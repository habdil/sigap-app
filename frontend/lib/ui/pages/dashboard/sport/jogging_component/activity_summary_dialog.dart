import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';

class ActivitySummaryDialog extends StatelessWidget {
  final Map<String, dynamic> activityData;
  final VoidCallback onShare;

  const ActivitySummaryDialog({
    Key? key,
    required this.activityData,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract data from the activity data map
    final double distance = activityData['distance'] ?? 0.0;
    final int durationInSeconds = activityData['durationInSeconds'] ?? 0;
    final double pace = activityData['pace'] ?? 0.0;
    final int calories = activityData['calories'] ?? 0;
    final int steps = activityData['steps'] ?? 0;
    final int heartRateAvg = activityData['heartRateAvg'] ?? 0;
    final int coins = activityData['coins'] ?? 0;

    return AlertDialog(
      title: Text('Activity Summary', style: blackTextStyle.copyWith(fontWeight: semiBold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Distance', '${distance.toStringAsFixed(2)} km'),
          _buildSummaryRow('Duration', _formatDuration(durationInSeconds)),
          _buildSummaryRow('Avg. Pace', '${pace.toStringAsFixed(1)} min/km'),
          _buildSummaryRow('Calories', '$calories kcal'),
          _buildSummaryRow('Steps', '$steps steps'),
          _buildSummaryRow('Heart Rate', '$heartRateAvg bpm'),
          _buildSummaryRow('Coins Earned', '$coins coins'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: orangeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Great job! You\'ve earned $coins coins for your ${(durationInSeconds / 60).toStringAsFixed(0)}-minute jogging session.',
                    style: blackTextStyle.copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Share', style: blueTextStyle),
          onPressed: onShare,
        ),
        TextButton(
          child: Text('Close', style: orangeTextStyle),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: greyTextStyle),
          Text(value, style: blackTextStyle.copyWith(fontWeight: semiBold)),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }
}
