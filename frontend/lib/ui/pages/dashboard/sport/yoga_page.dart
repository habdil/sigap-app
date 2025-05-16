import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/sport/yoga/timer_display.dart';
import 'package:frontend/ui/widgets/sport/yoga/yoga_app_bar.dart';
import 'package:frontend/ui/widgets/sport/yoga/yoga_visualization.dart';
import 'package:frontend/ui/widgets/sport/yoga/yoga_control_buttons.dart';
import 'package:frontend/ui/widgets/sport/yoga/music_player.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/blocs/activity_bloc.dart';
import 'package:frontend/models/activity_model.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

class YogaPage extends StatefulWidget {
  const YogaPage({Key? key}) : super(key: key);

  @override
  State<YogaPage> createState() => _YogaPageState();
}

class _YogaPageState extends State<YogaPage> {
  bool _isRunning = false;
  bool _isPaused = false;
  int _timerInSeconds = 0;  // Ini masalahnya! Default 0 berarti timer langsung selesai
  int _totalSessionDuration = 0; // Track total duration for saving to database
  DateTime? _sessionStartTime;
  Timer? _timer;
  
  // Music player state
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentSongIndex = 0;
  bool _isPlaying = false;
  double _songProgress = 0.0;
  Timer? _songTimer;
  
  // Actual music files from assets
  final List<String> _yogaMusicFiles = [
    'music/music-1.mp3',
    'music/music-2.mp3',
    'music/music-3.mp3',
    'music/music-4.mp3',
    'music/music-5.mp3',
  ];
  
  // Display names for music files
  final List<String> _yogaMusicNames = [
    'Calm Meditation',
    'Peaceful Flow',
    'Mindful Breathing',
    'Gentle Harmony',
    'Serene Balance',
  ];
  
  // Weather data
  String _weatherCondition = 'Clear';
  int _temperature = 28;
  
  // Location data - DUMMY DATA
  Map<String, dynamic> _locationData = {
    'latitude': -7.7956,
    'longitude': 110.3695,
    'timestamp': DateTime.now().toIso8601String(),
  };
  
  @override
  void initState() {
    super.initState();
    // Set default timer value ke 15 menit (900 detik)
    _timerInSeconds = 900;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _songTimer?.cancel();
    _audioPlayer.dispose();
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
                _handleStop(saveActivity: true);
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
                  _handleStop(saveActivity: true);
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
                      _handleStop(saveActivity: false); // Reset current timer without saving
                      _timerInSeconds = minutes * 60;
                      setState(() {
                        _sessionStartTime = DateTime.now();
                      });
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
                value: _isPlaying,
                onChanged: (value) {
                  Navigator.pop(context);
                  if (value != _isPlaying) {
                    _togglePlayMusic();
                  }
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
              Text('Earn coins for each completed yoga session!', style: orangeTextStyle),
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
    if (_sessionStartTime == null) {
      _sessionStartTime = DateTime.now();
    }
    
    // Pastikan timer punya nilai awal jika 0
    if (_timerInSeconds <= 0) {
      _timerInSeconds = 900; // Default 15 menit (900 detik) jika timer kosong
    }
    
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    
    // Cancel timer yang berjalan jika ada
    _timer?.cancel();
    
    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _totalSessionDuration++; // Increment total duration
        
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
            
            // Save activity to database
            _saveActivityToDatabase();
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
    
    // Pause music
    _audioPlayer.pause();
    _songTimer?.cancel();
    
    context.showWarningNotification(
      title: 'Session Paused',
      message: 'Your yoga session is paused',
    );
  }
  
  void _handleStop({bool saveActivity = true}) {
    _timer?.cancel();
    
    // Stop music
    _audioPlayer.stop();
    _songTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
    
    // Show summary and save activity if there was any activity
    if (saveActivity && _totalSessionDuration > 0) {
      _saveActivityToDatabase();
      _showSessionSummary();
    }
    
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _timerInSeconds = 900; // Reset timer ke 15 menit (bukan 0)
      _totalSessionDuration = 0;
      _sessionStartTime = null;
    });
  }
  
  Future<void> _saveActivityToDatabase() async {
    if (_totalSessionDuration < 10) {
      // Don't save very short sessions (less than 10 seconds)
      return;
    }
    
    try {
      // Calculate calories burned (simplified formula for yoga)
      // Assuming average person burns ~3 calories per minute during yoga
      int caloriesBurned = (_totalSessionDuration / 60 * 3).round();
      
      // Calculate coins earned (1 coin per minute, rounded up)
      int coinsEarned = ((_totalSessionDuration / 60) + 0.5).floor();
      if (coinsEarned < 1) coinsEarned = 1; // Minimum 1 coin
      
      // Update timestamp in dummy location data
      _locationData['timestamp'] = DateTime.now().toIso8601String();
      
      // Create activity model
      final activity = ActivityModel(
        activityType: 'Yoga',
        durationMinutes: (_totalSessionDuration / 60).ceil(), // Convert seconds to minutes
        caloriesBurned: caloriesBurned,
        heartRateAvg: 75, // Default value for yoga
        activityDate: _sessionStartTime ?? DateTime.now(),
        notes: 'Yoga session',
        weatherCondition: _weatherCondition,
        locationData: _locationData,
        coinsEarned: coinsEarned,
        musicPlayed: _yogaMusicNames[_currentSongIndex],
      );
      
      // Use the ActivityBloc to save the activity
      final activityBloc = Provider.of<ActivityBloc>(context, listen: false);
      final result = await activityBloc.addActivity(activity);
      
      if (result) {
        print('Yoga activity saved successfully');
      } else {
        print('Failed to save yoga activity');
      }
    } catch (e) {
      print('Error saving yoga activity: $e');
    }
  }
  
  void _handleSkip() {
    if (_isRunning) {
      context.showWarningNotification(
        title: 'Pose Skipped',
        message: 'Moving to the next pose',
      );
    }
  }
  
  void _showSessionSummary() {
    // Calculate calories and duration for display
    int caloriesBurned = (_totalSessionDuration / 60 * 3).round();
    int durationMinutes = (_totalSessionDuration / 60).ceil();
    int coinsEarned = ((_totalSessionDuration / 60) + 0.5).floor();
    if (coinsEarned < 1) coinsEarned = 1; // Minimum 1 coin
    
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
              // Session stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Duration:', style: blackTextStyle),
                        Text('$durationMinutes minutes', style: blackTextStyle.copyWith(fontWeight: medium)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Calories:', style: blackTextStyle),
                        Text('$caloriesBurned cal', style: blackTextStyle.copyWith(fontWeight: medium)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Coins earned
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
                        'You\'ve earned $coinsEarned coins from this session!',
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
  Future<void> _togglePlayMusic() async {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    if (_isPlaying) {
      // Play the actual music file
      try {
        await _audioPlayer.play(AssetSource(_yogaMusicFiles[_currentSongIndex]));
        
        // Update progress bar
        _songTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
          try {
            final position = await _audioPlayer.getCurrentPosition() ?? Duration.zero;
            final duration = await _audioPlayer.getDuration() ?? Duration(minutes: 3);
            
            if (duration.inMilliseconds > 0) {
              setState(() {
                _songProgress = position.inMilliseconds / duration.inMilliseconds;
                
                // If song ended, play next
                if (_songProgress >= 0.99) {
                  _playNextSong();
                }
              });
            }
          } catch (e) {
            print('Error updating song progress: $e');
          }
        });
      } catch (e) {
        print('Error playing music: $e');
        context.showErrorNotification(
          title: 'Music Error',
          message: 'Could not play the selected music',
        );
      }
    } else {
      // Pause music
      await _audioPlayer.pause();
      _songTimer?.cancel();
    }
  }
  
  Future<void> _playPreviousSong() async {
    await _audioPlayer.stop();
    
    setState(() {
      _currentSongIndex = (_currentSongIndex - 1) % _yogaMusicFiles.length;
      if (_currentSongIndex < 0) _currentSongIndex = _yogaMusicFiles.length - 1;
      _songProgress = 0.0;
    });
    
    if (_isPlaying) {
      await _audioPlayer.play(AssetSource(_yogaMusicFiles[_currentSongIndex]));
    }
    
    context.showWarningNotification(
      title: 'Now Playing',
      message: _yogaMusicNames[_currentSongIndex],
    );
  }
  
  Future<void> _playNextSong() async {
    await _audioPlayer.stop();
    
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _yogaMusicFiles.length;
      _songProgress = 0.0;
    });
    
    if (_isPlaying) {
      await _audioPlayer.play(AssetSource(_yogaMusicFiles[_currentSongIndex]));
    }
    
    context.showWarningNotification(
      title: 'Now Playing',
      message: _yogaMusicNames[_currentSongIndex],
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
                                '$_temperature°C',
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
                              subtitle: _isRunning ? 'Session in progress' : 'Ready to start',
                            ),
                            
                            SizedBox(height: constraints.maxHeight * 0.05),
                            
                            // Control Buttons
                            YogaControlButtons(
                              isRunning: _isRunning,
                              isPaused: _isPaused,
                              onStart: _handleStart,
                              onPause: _handlePause,
                              onStop: () => _handleStop(saveActivity: true),
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
                              currentSong: _yogaMusicNames[_currentSongIndex],
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