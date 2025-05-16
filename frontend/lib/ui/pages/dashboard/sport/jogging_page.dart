import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/models/user_profile_model.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/shared/theme.dart';
import 'package:frontend/ui/widgets/sport/jogging/activity_metrics.dart';
import 'package:frontend/ui/widgets/sport/jogging/activity_stats.dart';
import 'package:frontend/ui/widgets/sport/jogging/control_buttons.dart';
import 'package:frontend/ui/widgets/sport/jogging/distance_display.dart';
import 'package:frontend/ui/widgets/sport/jogging/jogging_app_bar.dart';
import 'package:frontend/ui/widgets/sport/jogging/route_visualization.dart';
import 'package:frontend/ui/widgets/sport/jogging/weather_gps_info.dart';
import 'package:frontend/shared/notification.dart';
import 'package:frontend/models/activity_model.dart';
import 'package:frontend/blocs/activity_bloc.dart';
import 'package:frontend/models/coin_transaction_model.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:frontend/ui/pages/dashboard/sport/jogging_component/confirmation_dialog.dart';
import 'package:frontend/ui/pages/dashboard/sport/jogging_component/menu_bottom_sheet.dart';
import 'package:frontend/ui/pages/dashboard/sport/jogging_component/settings_dialog.dart';
import 'package:frontend/ui/pages/dashboard/sport/jogging_component/history_dialog.dart';
import 'package:frontend/ui/pages/dashboard/sport/jogging_component/help_dialog.dart';
import 'package:frontend/ui/pages/dashboard/sport/jogging_component/activity_summary_dialog.dart';

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
  double _userWeight = 70.0; // Default weight in kg (akan diganti dengan data pengguna asli jika tersedia)
  
  // Time tracking
  Timer? _timer;
  DateTime? _startTime;
  DateTime? _currentTime;
  int _elapsedPauseTime = 0;
  
  // Activity data for simulation
  final Random _random = math.Random();
  final List<double> _speedVariations = [];
  
  // For tracking the route (dummy data)
  final Map<String, dynamic> _locationData = {
    'start': {'lat': -7.755, 'lng': 110.408},
    'end': {'lat': -7.759, 'lng': 110.415},
    'path': []
  };
  
  // Heart rate simulation
  int _heartRateAvg = 0;
  
  // Weather condition (dummy data)
  String _weatherCondition = 'Sunny';
  
  late ActivityBloc _activityBloc;
  bool _isSavingActivity = false;
  
  @override
  void initState() {
    super.initState();
    // Generate random speed variations for simulation
    for (int i = 0; i < 30; i++) {
      _speedVariations.add(2.0 + _random.nextDouble() * 3.0); // Speeds between 2.0 and 5.0 km/h
    }
    
    // Initialize heart rate
    _heartRateAvg = 70 + _random.nextInt(20);
    
    // Get the activity bloc
    _activityBloc = Provider.of<ActivityBloc>(context, listen: false);
    
    // TODO: Get user weight from user profile if available
    _getUserWeight();
  }
  
  // Metode untuk mendapatkan berat badan pengguna dari profil
  Future<void> _getUserWeight() async {
    try {
      print('Fetching user profile data for weight calculation');
      
      // Menggunakan ProfileService untuk mendapatkan data profil pengguna
      final profileResult = await ProfileService.getProfile();
      
      if (profileResult['success'] && profileResult['data'] != null) {
        final UserProfile profile = profileResult['data'];
        
        setState(() {
          // Menggunakan berat dari profil atau default 70.0 kg jika tidak ada
          _userWeight = profile.weight ?? 70.0;
          print('User weight set to: $_userWeight kg');
          
          // Jika sudah ada data aktivitas, kita perlu menghitung ulang kalori
          if (_durationInSeconds > 0) {
            // Hitung ulang kalori berdasarkan berat pengguna baru
            double durationHours = _durationInSeconds / 3600.0;
            _calories = (7.0 * _userWeight * durationHours).round();
          }
        });
      } else {
        print('Failed to get user profile: ${profileResult['message']}');
        // Tetap gunakan berat default jika gagal mendapatkan profil
      }
    } catch (e) {
      print('Error getting user weight: $e');
      // Berat default tetap digunakan jika ada error
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _handleBackPressed() {
    if (_isRunning || _isPaused) {
      showConfirmationDialog(
        context: context,
        onEndActivity: () {
          _handleStop();
          Navigator.pop(context);
        },
      );
    } else {
      Navigator.pop(context);
    }
  }
  
  void _handleMenuPressed() {
    showMenuBottomSheet(
      context: context,
      isRunning: _isRunning,
      isPaused: _isPaused,
      onSettingsTap: _showSettingsDialog,
      onHistoryTap: _showHistoryDialog,
      onHelpTap: _showHelpDialog,
      onEndActivityTap: _handleStop,
    );
  }
  
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SettingsDialog(
          isGpsActive: _isGpsActive,
          onGpsChanged: (value) {
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
          onVoiceFeedbackChanged: (value) {
            context.showSuccessNotification(
              title: 'Voice Feedback',
              message: value ? 'Enabled' : 'Disabled',
            );
          },
        );
      },
    );
  }
  
  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const HistoryDialog();
      },
    );
  }
  
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const HelpDialog();
      },
    );
  }
  
  void _handleStart() {
    if (!_isRunning && !_isPaused) {
      // Starting a new activity
      _startTime = DateTime.now();
      _currentTime = _startTime;
      _elapsedPauseTime = 0;
      
      // Reset location path for new activity
      _locationData['path'] = [];
      
      // Add starting point to path
      _addPathPoint();
      
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
      
      // Simulate heart rate increase when running starts
      _heartRateAvg = 110 + _random.nextInt(40);
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
          _steps = newSteps;
          
          // Every 5 seconds, add a path point for route visualization
          if (_durationInSeconds % 5 == 0) {
            _addPathPoint();
          }
        } else {
          // Less accurate if GPS is off
          double distanceIncrease = (2.5 + _random.nextDouble()) / 3600.0;
          _distance += distanceIncrease;
          
          // Simulate steps (roughly 1 step per second without GPS)
          _steps += 1;
        }
        
        // Calculate pace (min/km)
        if (_distance > 0) {
          _pace = _durationInSeconds / 60 / _distance;
        }
        
        // Calculate calories burned using MET formula from backend
        // MET for jogging is 7.0
        double durationHours = _durationInSeconds / 3600.0;
        _calories = (7.0 * _userWeight * durationHours).round();
        
        // Calculate coins using backend formula - will be properly calculated at the end
        // This is just for UI display during activity
        _updateCoinsForUI();
        
        // Simulate heart rate variations
        if (_durationInSeconds % 20 == 0) {
          // Every 20 seconds, slightly adjust heart rate
          _heartRateAvg += _random.nextInt(11) - 5; // -5 to +5 change
          
          // Keep heart rate in a realistic range
          if (_heartRateAvg < 100) _heartRateAvg = 100 + _random.nextInt(10);
          if (_heartRateAvg > 180) _heartRateAvg = 180 - _random.nextInt(10);
        }
      });
    });
  }
  
  void _updateCoinsForUI() {
    // Perhitungan koin sesuai dengan backend
    // Jogging = 0.4 koin per menit
    double durationMinutes = _durationInSeconds / 60.0;
    double baseCoins = 0.4 * durationMinutes;
    
    // Bonus untuk aktivitas yang lebih lama
    double bonus = 0;
    if (durationMinutes >= 60) {
      bonus = 10; // Bonus besar untuk 1 jam+
    } else if (durationMinutes >= 45) {
      bonus = 5;
    } else if (durationMinutes >= 30) {
      bonus = 3;
    }
    
    _coins = (baseCoins + bonus).round();
  }
  
  void _addPathPoint() {
    // Generate a random point deviation from the last point or starting point
    double latBase = _locationData['start']['lat'];
    double lngBase = _locationData['start']['lng'];
    
    if (_locationData['path'].isNotEmpty) {
      // Use the last point as the base
      latBase = _locationData['path'].last['lat'];
      lngBase = _locationData['path'].last['lng'];
    }
    
    // Add a small random deviation to simulate movement
    double latDev = (_random.nextDouble() - 0.5) * 0.001; // Small lat deviation
    double lngDev = (_random.nextDouble() - 0.3) * 0.001; // Small lng deviation, slightly biased towards end
    
    // Add the new point to the path
    _locationData['path'].add({
      'lat': latBase + latDev,
      'lng': lngBase + lngDev,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  void _handlePause() {
    _timer?.cancel();
    
    setState(() {
      _isRunning = false;
      _isPaused = true;
      _currentTime = DateTime.now();
      
      // Simulate heart rate decrease when paused
      _heartRateAvg = max(70, _heartRateAvg - 20);
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
      // Set the end point of the route
      _locationData['end'] = {
        'lat': _locationData['path'].isEmpty ? 
              _locationData['start']['lat'] : 
              _locationData['path'].last['lat'],
        'lng': _locationData['path'].isEmpty ? 
              _locationData['start']['lng'] : 
              _locationData['path'].last['lng'],
      };
      
      // Recalculate coins finally using backend logic
      _calculateFinalCoins();
      
      // First save activity to backend
      _saveActivityToBackend();
      
      // Then show summary
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
      _coins = 0; // Reset coins for next session
    });
  }
  
  void _calculateFinalCoins() {
    // Use the backend coin calculation logic
    // Untuk Jogging: 0.4 koin per menit
    double durationMinutes = _durationInSeconds / 60.0;
    double baseCoins = 0.4 * durationMinutes;
    
    // Tambahkan bonus untuk aktivitas yang lebih lama
    double bonus = 0;
    if (durationMinutes >= 60) {
      bonus = 10; // Bonus besar untuk 1 jam+
    } else if (durationMinutes >= 45) {
      bonus = 5;
    } else if (durationMinutes >= 30) {
      bonus = 3;
    }
    
    _coins = (baseCoins + bonus).round();
    print('Final coins earned: $_coins (${durationMinutes.toStringAsFixed(1)} minutes)');
  }
  
  Future<void> _saveActivityToBackend() async {
    if (_isSavingActivity) return; // Prevent multiple save attempts
    
    setState(() {
      _isSavingActivity = true;
    });
    
    try {
      print("Creating activity with weather: $_weatherCondition");
      
      // Make sure the duration is at least 1 minute for the API
      int durationMinutes = max(1, (_durationInSeconds / 60).ceil());
      
      final activityModel = ActivityModel(
        activityType: 'Jogging',
        durationMinutes: durationMinutes,
        distanceKm: _distance,
        caloriesBurned: _calories,
        heartRateAvg: _heartRateAvg,
        activityDate: DateTime.now(),
        notes: 'Jogging session',
        weatherCondition: _weatherCondition,
        locationData: _locationData,
        avgPace: _pace,
        coinsEarned: _coins, // Menggunakan perhitungan koin yang benar
        musicPlayed: 'User playlist', // Dummy data
      );
      
      print('Saving activity to backend: ${activityModel.toJson()}');
      
      try {
        // Coba kirim ke backend
        final result = await _activityBloc.addActivity(activityModel);
        
        if (result) {
          print('Activity saved successfully to backend');
          await _activityBloc.getActivities();
          
          context.showSuccessNotification(
            title: 'Activity Saved',
            message: 'Your jogging session was successfully recorded',
          );
        } else {
          print('Failed to save activity to backend: ${_activityBloc.errorMessage}');
          
          context.showErrorNotification(
            title: 'Save Error',
            message: 'Failed to save activity: ${_activityBloc.errorMessage}',
          );
        }
      } catch (e) {
        print('Error saving to backend: $e');
        
        context.showErrorNotification(
          title: 'Error',
          message: 'An error occurred while saving your activity',
        );
      }
    } finally {
      setState(() {
        _isSavingActivity = false;
      });
    }
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
    // Create a snapshot of the current activity data to pass to the dialog
    final activityData = {
      'distance': _distance,
      'durationInSeconds': _durationInSeconds,
      'pace': _pace,
      'calories': _calories,
      'steps': _steps,
      'heartRateAvg': _heartRateAvg,
      'coins': _coins,
    };
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ActivitySummaryDialog(
          activityData: activityData,
          onShare: () {
            Navigator.of(context).pop();
            context.showSuccessNotification(
              title: 'Sharing',
              message: 'Activity shared successfully!',
            );
          },
        );
      },
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
    
    // Today's date for display
    final today = DateTime.now();
    final formattedDate = '${today.day} ${_getMonthName(today.month)} ${today.year}';
    final formattedTime = '${today.hour.toString().padLeft(2, '0')}:${today.minute.toString().padLeft(2, '0')}';
    
    return WillPopScope(
      onWillPop: () async {
        if (_isRunning || _isPaused) {
          _handleBackPressed();
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
                            // Route Visualization - pass location data if you want to use it
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
                            
                            // Activity Stats with Graph - Updated reward text
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ActivityStats(
                                date: formattedDate,
                                time: formattedTime,
                                steps: _steps,
                                reward: '0.4 Coins/min',
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
  
  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
}
