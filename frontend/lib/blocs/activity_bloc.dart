// lib/blocs/activity_bloc.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/activity_model.dart';
import 'package:frontend/services/activity_service.dart';

enum ActivityBlocState {
  initial,
  loading,
  loaded,
  error,
}

class ActivityBloc extends ChangeNotifier {
  ActivityBlocState _state = ActivityBlocState.initial;
  List<ActivityModel> _activities = [];
  String _errorMessage = '';
  bool _isAddingActivity = false;

  // Getters
  ActivityBlocState get state => _state;
  List<ActivityModel> get activities => _activities;
  String get errorMessage => _errorMessage;
  bool get isAddingActivity => _isAddingActivity;

  // Metode untuk mengambil daftar aktivitas
  Future<void> getActivities() async {
    try {
      print('ActivityBloc: Starting getActivities');
      _state = ActivityBlocState.loading;
      notifyListeners();

      final result = await ActivityService.getActivities();
      
      if (result['success']) {
        _activities = result['data'];
        _state = ActivityBlocState.loaded;
        print('ActivityBloc: Successfully loaded ${_activities.length} activities');
      } else {
        _errorMessage = result['message'];
        _state = ActivityBlocState.error;
        print('ActivityBloc: Error getting activities: $_errorMessage');
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _state = ActivityBlocState.error;
      print('ActivityBloc: Exception in getActivities: $e');
    } finally {
      notifyListeners();
    }
  }

  // Metode untuk menambahkan aktivitas baru
  Future<bool> addActivity(ActivityModel activity) async {
    try {
      print('ActivityBloc: Starting addActivity for ${activity.activityType}');
      _isAddingActivity = true;
      notifyListeners();

      final result = await ActivityService.addActivity(activity);
      
      if (result['success']) {
        // Tambahkan aktivitas baru ke daftar jika berhasil
        if (result['data'] is ActivityModel) {
          _activities.insert(0, result['data']);
          print('ActivityBloc: Successfully added new activity');
        }
        // Setelah menambahkan aktivitas, refresh daftar aktivitas
        await getActivities();
        return true;
      } else {
        _errorMessage = result['message'];
        print('ActivityBloc: Error adding activity: $_errorMessage');
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      print('ActivityBloc: Exception in addActivity: $e');
      return false;
    } finally {
      _isAddingActivity = false;
      notifyListeners();
    }
  }

  // Method untuk mendapatkan aktivitas berdasarkan tipe
  List<ActivityModel> getActivitiesByType(String type) {
    return _activities.where((activity) => activity.activityType == type).toList();
  }

  // Method untuk mendapatkan total durasi aktivitas
  int getTotalDuration() {
    return _activities.fold(0, (sum, activity) => sum + activity.durationMinutes);
  }

  // Method untuk mendapatkan total kalori yang dibakar
  int getTotalCaloriesBurned() {
    return _activities.fold(0, (sum, activity) => sum + (activity.caloriesBurned ?? 0));
  }

  // Method untuk mendapatkan total jarak yang ditempuh (khusus Jogging)
  double getTotalDistance() {
    return _activities
        .where((activity) => activity.activityType == 'Jogging')
        .fold(0.0, (sum, activity) => sum + (activity.distanceKm ?? 0));
  }

  // Reset state ke initial
  void reset() {
    _state = ActivityBlocState.initial;
    _activities = [];
    _errorMessage = '';
    _isAddingActivity = false;
    notifyListeners();
  }
}