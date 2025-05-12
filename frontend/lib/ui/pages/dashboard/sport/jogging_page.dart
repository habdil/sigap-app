import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/sport/jogging/activity_metrics.dart';
import 'package:frontend/ui/widgets/sport/jogging/activity_stats.dart';
import 'package:frontend/ui/widgets/sport/jogging/control_buttons.dart';
import 'package:frontend/ui/widgets/sport/jogging/distance_display.dart';
import 'package:frontend/ui/widgets/sport/jogging/jogging_app_bar.dart';
import 'package:frontend/ui/widgets/sport/jogging/route_visualization.dart';
import 'package:frontend/ui/widgets/sport/jogging/weather_gps_info.dart';
import 'package:frontend/shared/notification.dart';
import 'dart:math' as math;

class JoggingPage extends StatefulWidget {
  const JoggingPage({Key? key}) : super(key: key);

  @override
  State<JoggingPage> createState() => _JoggingPageState();
}

class _JoggingPageState extends State<JoggingPage> {
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isGpsActive = true;
  
  // Activity metrics
  double _distance = 0.0;
  int _durationInSeconds = 0;
  double _pace = 0.0;
  int _calories = 0;
  int _steps = 0;
  int _coins = 0;
  
  // Time tracking
  Timer? _timer;
  DateTime? _startTime;
  DateTime? _currentTime;
  int _elapsedPauseTime = 0;
  
  // Activity data for simulation
  final Random _random = math.Random();
  final List<double> _speedVariations = [];
  
  @override
  void initState() {
    super.initState();
    // Generate random speed variations for simulation
    for (int i = 0; i < 30; i++) {
      _speedVariations.add(2.0 + _random.nextDouble() * 3.0); // Speeds between 2.0 and 5.0 km/h
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _handleBackPressed() {
    if (_isRunning) {
      _showConfirmationDialog();
    } else {
      Navigator.pop(context);
    }
  }
  
  void _showConfirmationDialog() {
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
                _handleStop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  
  void _handleMenuPressed() {
    // Show menu options
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
                // Show settings dialog
                _showSettingsDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: blackColor),
              title: Text('Activity History', style: blackTextStyle),
              onTap: () {
                Navigator.pop(context);
                // Show activity history dialog
                _showHistoryDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: blackColor),
              title: Text('Help', style: blackTextStyle),
              onTap: () {
                Navigator.pop(context);
                // Show help dialog
                _showHelpDialog();
              },
            ),
            if (_isRunning || _isPaused)
              ListTile(
                leading: Icon(Icons.stop_circle, color: Colors.red),
                title: Text('End Activity', style: blackTextStyle),
                onTap: () {
                  Navigator.pop(context);
                  _handleStop();
                },
              ),
          ],
        ),
      ),
    );
  }
  
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings', style: blackTextStyle.copyWith(fontWeight: semiBold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text('GPS Tracking', style: blackTextStyle),
                value: _isGpsActive,
                onChanged: (value) {
                  Navigator.pop(context);
                  setState(() {
                    _isGpsActive = value;
                  });
                  
                  if (!value) {
                    context.showWarningNotification(
                      title: 'GPS Disabled',
                      message: 'Distance tracking may be less accurate',
                    );
                  } else {
                    context.showSuccessNotification(
                      title: 'GPS Enabled',
                      message: 'Using GPS for accurate tracking',
                    );
                  }
                },
              ),
              SwitchListTile(
                title: Text('Voice Feedback', style: blackTextStyle),
                value: true,
                onChanged: (value) {
                  Navigator.pop(context);
                  context.showSuccessNotification(
                    title: 'Voice Feedback',
                    message: value ? 'Enabled' : 'Disabled',
                  );
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
      },
    );
  }
  
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
      },
    );
  }
  
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
              Text('Earn 1 coin for each step you take!', style: orangeTextStyle),
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
      },
    );
  }
  
  void _handleStart() {
    if (!_isRunning && !_isPaused) {
      // Starting a new activity
      _startTime = DateTime.now();
      _currentTime = _startTime;
      _elapsedPauseTime = 0;
      
      context.showSuccessNotification(
        title: 'Activity Started',
        message: 'Your running session has begun',
      );
    } else if (_isPaused) {
      // Resuming from pause
      _elapsedPauseTime += DateTime.now().difference(_currentTime!).inSeconds;
      
      context.showSuccessNotification(
        title: 'Activity Resumed',
        message: 'Continue your run',
      );
    }
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    
    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
        _durationInSeconds = _currentTime!.difference(_startTime!).inSeconds - _elapsedPauseTime;
        
        // Simulate distance increase
        if (_isGpsActive) {
          int speedIndex = _durationInSeconds % _speedVariations.length;
          double speed = _speedVariations[speedIndex]; // km/h
          double distanceIncrease = speed / 3600.0; // Convert km/h to km/s
          _distance += distanceIncrease;
          
          // Simulate steps (roughly 1.3 steps per second for jogging)
          int newSteps = (_steps + (1 + _random.nextInt(2))).toInt();
          int stepsDifference = newSteps - _steps;
          _steps = newSteps;
          
          // Add coins based on steps
          _coins += stepsDifference;
        } else {
          // Less accurate if GPS is off
          double distanceIncrease = (2.5 + _random.nextDouble()) / 3600.0;
          _distance += distanceIncrease;
          
          // Simulate steps (roughly 1 step per second without GPS)
          _steps += 1;
          _coins += 1;
        }
        
        // Calculate pace (min/km)
        if (_distance > 0) {
          _pace = _durationInSeconds / 60 / _distance;
        }
        
        // Calculate calories burned
        // Simple formula: ~60 calories per km for a 70kg person
        _calories = (_distance * 60).toInt();
      });
    });
  }
  
  void _handlePause() {
    _timer?.cancel();
    
    setState(() {
      _isRunning = false;
      _isPaused = true;
      _currentTime = DateTime.now();
    });
    
    context.showWarningNotification(
      title: 'Activity Paused',
      message: 'Your activity tracking is paused',
    );
  }
  
  void _handleStop() {
    _timer?.cancel();
    
    // Show activity summary if there was actual activity
    if (_distance > 0 || _durationInSeconds > 0) {
      _showActivitySummary();
    }
    
    setState(() {
      _isRunning = false;
      _isPaused = false;
      // Reset metrics for new activity
      _distance = 0.0;
      _durationInSeconds = 0;
      _pace = 0.0;
      _calories = 0;
      _steps = 0;
      // Keep coins earned
    });
  }
  
  void _handleFlag() {
    if (_isRunning) {
      // Simulate marking a lap
      context.showSuccessNotification(
        title: 'Lap Marked',
        message: 'Lap time recorded',
      );
    }
  }
  
  void _showActivitySummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Activity Summary', style: blackTextStyle.copyWith(fontWeight: semiBold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow('Distance', '${_distance.toStringAsFixed(2)} km'),
              _buildSummaryRow('Duration', _formatDuration(_durationInSeconds)),
              _buildSummaryRow('Avg. Pace', '${_pace.toStringAsFixed(1)} min/km'),
              _buildSummaryRow('Calories', '$_calories kcal'),
              _buildSummaryRow('Steps', '$_steps steps'),
              _buildSummaryRow('Coins Earned', '$_coins coins'),
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
                        'Great job! You\'ve earned $_coins coins from this activity.',
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
              onPressed: () {
                Navigator.of(context).pop();
                context.showSuccessNotification(
                  title: 'Sharing',
                  message: 'Activity shared successfully!',
                );
              },
            ),
            TextButton(
              child: Text('Close', style: orangeTextStyle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context) {
    // Get screen size to handle different device sizes
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    
    // Format values for display
    final formattedDistance = _distance.toStringAsFixed(2);
    final formattedDuration = _formatDuration(_durationInSeconds);
    final formattedPace = _pace > 0 ? '${_pace.toStringAsFixed(1)}/km' : '0.0/km';
    final formattedCalories = '$_calories';
    
    return WillPopScope(
      onWillPop: () async {
        if (_isRunning) {
          _showConfirmationDialog();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // App Bar
                  JoggingAppBar(
                    activity: 'Running',
                    onBackPressed: _handleBackPressed,
                    onMenuPressed: _handleMenuPressed,
                  ),
                  
                  // Weather and GPS Info
                  WeatherGpsInfo(
                    temperature: '32°C',
                    isGpsActive: _isGpsActive,
                  ),
                  
                  // Content with Expanded to take available space
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            // Route Visualization
                            const RouteVisualization(),
                            
                            // Distance Display
                            DistanceDisplay(distance: formattedDistance),
                            
                            // Metrics (Duration, Pace, Calories)
                            ActivityMetrics(
                              duration: formattedDuration,
                              pace: formattedPace,
                              calories: formattedCalories,
                            ),
                            
                            SizedBox(height: constraints.maxHeight * 0.05),
                            
                            // Activity Stats with Graph
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ActivityStats(
                                date: '5 Dec 2025',
                                time: '10:48',
                                steps: _steps,
                                reward: '+1 Coin/step',
                                coins: _coins,
                              ),
                            ),
                            
                            // Extra space at bottom to ensure stats are visible above buttons
                            SizedBox(height: constraints.maxHeight * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Control Buttons at the bottom with fixed height
                  Container(
                    padding: EdgeInsets.only(bottom: paddingBottom > 0 ? paddingBottom : 16.0),
                    child: ControlButtons(
                      isRunning: _isRunning,
                      isPaused: _isPaused,
                      onStart: _handleStart,
                      onPause: _handlePause,
                      onStop: _handleStop,
                      onFlag: _handleFlag,
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}