import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/sport/yoga/timer_display.dart';
import 'package:frontend/ui/widgets/sport/yoga/yoga_app_bar.dart';
import 'package:frontend/ui/widgets/sport/yoga/yoga_visualization.dart';
import 'package:frontend/ui/widgets/sport/yoga/yoga_control_buttons.dart';
import 'package:frontend/ui/widgets/sport/yoga/music_player.dart';
import 'package:frontend/shared/notification.dart';

class YogaPage extends StatefulWidget {
  const YogaPage({Key? key}) : super(key: key);

  @override
  State<YogaPage> createState() => _YogaPageState();
}

class _YogaPageState extends State<YogaPage> {
  bool _isRunning = false;
  bool _isPaused = false;
  int _timerInSeconds = 0;
  Timer? _timer;
  
  // Music player state
  String _currentSong = 'Calm music for yoga';
  bool _isPlaying = false;
  double _songProgress = 0.0;
  Timer? _songTimer;
  List<String> _yogaMusic = [
    'Calm music for yoga',
    'Meditation sounds',
    'Relaxing nature',
    'Peaceful harmony',
    'Deep breathing focus'
  ];
  
  @override
  void dispose() {
    _timer?.cancel();
    _songTimer?.cancel();
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
          title: Text('End Yoga Session', style: blackTextStyle.copyWith(fontWeight: semiBold)),
          content: Text(
            'Do you want to end your current yoga session?',
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
              leading: Icon(Icons.fitness_center, color: blackColor),
              title: Text('Yoga Poses', style: blackTextStyle),
              onTap: () {
                Navigator.pop(context);
                _showYogaPosesDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: blackColor),
              title: Text('Settings', style: blackTextStyle),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: blackColor),
              title: Text('Help', style: blackTextStyle),
              onTap: () {
                Navigator.pop(context);
                _showHelpDialog();
              },
            ),
            if (_isRunning || _isPaused)
              ListTile(
                leading: Icon(Icons.stop_circle, color: Colors.red),
                title: Text('End Session', style: blackTextStyle),
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
  
  void _showYogaPosesDialog() {
    final poses = [
      {'name': 'Mountain Pose', 'duration': '1 min', 'level': 'Beginner'},
      {'name': 'Downward Dog', 'duration': '2 min', 'level': 'Beginner'},
      {'name': 'Warrior I', 'duration': '1 min', 'level': 'Intermediate'},
      {'name': 'Tree Pose', 'duration': '1 min', 'level': 'Beginner'},
      {'name': 'Triangle Pose', 'duration': '2 min', 'level': 'Intermediate'},
    ];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recommended Poses', style: blackTextStyle.copyWith(fontWeight: semiBold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: poses.length,
              itemBuilder: (context, index) {
                final pose = poses[index];
                return ListTile(
                  title: Text(pose['name']!, style: blackTextStyle),
                  subtitle: Text('${pose['duration']} • ${pose['level']}', style: greyTextStyle),
                  trailing: IconButton(
                    icon: Icon(Icons.play_circle_outline, color: orangeColor),
                    onPressed: () {
                      Navigator.pop(context);
                      context.showSuccessNotification(
                        title: 'Pose Selected',
                        message: 'Starting ${pose['name']} for ${pose['duration']}',
                      );
                      
                      // Set timer based on pose duration
                      int minutes = int.parse(pose['duration']!.split(' ')[0]);
                      _handleStop(); // Reset current timer
                      _timerInSeconds = minutes * 60;
                      setState(() {});
                      _handleStart(); // Start new timer
                    },
                  ),
                );
              },
            ),
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
                title: Text('Voice Guidance', style: blackTextStyle),
                value: true,
                onChanged: (value) {
                  Navigator.pop(context);
                  context.showSuccessNotification(
                    title: 'Voice Guidance',
                    message: value ? 'Enabled' : 'Disabled',
                  );
                },
              ),
              SwitchListTile(
                title: Text('Background Music', style: blackTextStyle),
                value: true,
                onChanged: (value) {
                  Navigator.pop(context);
                  setState(() {
                    _isPlaying = value;
                  });
                  context.showSuccessNotification(
                    title: 'Background Music',
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
  
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yoga Session Help', style: blackTextStyle.copyWith(fontWeight: semiBold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to use Yoga Timer:', style: blackTextStyle.copyWith(fontWeight: medium)),
              const SizedBox(height: 8),
              Text('• Press PLAY to start the timer', style: blackTextStyle),
              Text('• Press PAUSE to pause your session', style: blackTextStyle),
              Text('• Press STOP to end the session', style: blackTextStyle),
              Text('• Use music controls for relaxing sounds', style: blackTextStyle),
              const SizedBox(height: 8),
              Text('Try to maintain each pose for the full duration!', style: orangeTextStyle),
              const SizedBox(height: 8),
              Text('Earn 1 point for each completed yoga session!', style: orangeTextStyle),
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
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    
    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerInSeconds > 0) {
          _timerInSeconds--;
        } else {
          // If countdown mode and reaches zero
          _timer?.cancel();
          _isRunning = false;
          _isPaused = false;
          
          // Show completion notification
          if (mounted) {
            context.showSuccessNotification(
              title: 'Yoga Session Complete',
              message: 'Great job! Take a moment to relax.',
            );
          }
        }
      });
    });
    
    // Start playing music if not already playing
    if (!_isPlaying) {
      _togglePlayMusic();
    }
    
    context.showSuccessNotification(
      title: 'Session Started',
      message: 'Your yoga session has begun',
    );
  }
  
  void _handlePause() {
    _timer?.cancel();
    
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
    
    context.showWarningNotification(
      title: 'Session Paused',
      message: 'Your yoga session is paused',
    );
  }
  
  void _handleStop() {
    _timer?.cancel();
    
    // Show summary if there was any activity
    if (_timerInSeconds > 0 || _isRunning || _isPaused) {
      _showSessionSummary();
    }
    
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _timerInSeconds = 0;
    });
  }
  
  void _handleSkip() {
    if (_isRunning) {
      context.showInfoNotification(
        title: 'Pose Skipped',
        message: 'Moving to the next pose',
      );
    }
  }
  
  void _showSessionSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yoga Session Summary', style: blackTextStyle.copyWith(fontWeight: semiBold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/ic_yoga.png',
                width: 60,
                height: 60,
                color: orangeColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.self_improvement, size: 60, color: orangeColor);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Great job!',
                style: blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You\'ve completed your yoga session.',
                style: blackTextStyle,
                textAlign: TextAlign.center,
              ),
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
                        'You\'ve earned 1 point from this session!',
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
                  message: 'Session shared successfully!',
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
  
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    
    return '$hoursStr.$minutesStr.$secondsStr';
  }
  
  // Music player methods
  void _togglePlayMusic() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    if (_isPlaying) {
      // Simulate music playing with progress
      _songTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _songProgress += 0.001;
          if (_songProgress >= 1.0) {
            _songProgress = 0.0;
            _playNextSong();
          }
        });
      });
    } else {
      _songTimer?.cancel();
    }
  }
  
  void _playPreviousSong() {
    final currentIndex = _yogaMusic.indexOf(_currentSong);
    final previousIndex = (currentIndex - 1) % _yogaMusic.length;
    
    setState(() {
      _currentSong = _yogaMusic[previousIndex >= 0 ? previousIndex : _yogaMusic.length - 1];
      _songProgress = 0.0;
    });
    
    context.showInfoNotification(
      title: 'Now Playing',
      message: _currentSong,
    );
  }
  
  void _playNextSong() {
    final currentIndex = _yogaMusic.indexOf(_currentSong);
    final nextIndex = (currentIndex + 1) % _yogaMusic.length;
    
    setState(() {
      _currentSong = _yogaMusic[nextIndex];
      _songProgress = 0.0;
    });
    
    context.showInfoNotification(
      title: 'Now Playing',
      message: _currentSong,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    // Format values for display
    final formattedTime = _formatTime(_timerInSeconds);
    
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
                  YogaAppBar(
                    activity: 'Yoga',
                    onBackPressed: _handleBackPressed,
                    onMenuPressed: _handleMenuPressed,
                  ),
                  
                  // Weather info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.thermostat_outlined,
                                color: blackColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '32°C',
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content with Expanded to take available space
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            // Yoga Visualization
                            YogaVisualization(),
                            
                            // Timer Display
                            TimerDisplay(
                              time: formattedTime,
                              subtitle: 'Timer Support',
                            ),
                            
                            SizedBox(height: constraints.maxHeight * 0.05),
                            
                            // Control Buttons
                            YogaControlButtons(
                              isRunning: _isRunning,
                              isPaused: _isPaused,
                              onStart: _handleStart,
                              onPause: _handlePause,
                              onSkip: _handleSkip,
                            ),
                            
                            // Music player label
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Music For You',
                                style: blackTextStyle.copyWith(fontWeight: medium),
                              ),
                            ),
                            
                            // Music player
                            MusicPlayer(
                              currentSong: _currentSong,
                              isPlaying: _isPlaying,
                              progress: _songProgress,
                              onPlayToggle: _togglePlayMusic,
                              onPrevious: _playPreviousSong,
                              onNext: _playNextSong,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

extension NotificationExtensions on BuildContext {
  void showInfoNotification({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    CustomNotification.showNotification(
      this,
      title: title,
      message: message,
      type: NotificationType.warning,
      duration: duration,
    );
  }
}