// lib/models/activity_model.dart
import 'dart:convert';

class ActivityModel {
  final int? id;
  final int? userId;
  final String activityType;
  final int durationMinutes;
  final double? distanceKm;
  final int? caloriesBurned;
  final int? heartRateAvg;
  final DateTime? activityDate;
  final String? notes;
  final String? weatherCondition;
  final Map<String, dynamic>? locationData;
  final double? avgPace;
  final int? coinsEarned;
  final String? musicPlayed;

  ActivityModel({
    this.id,
    this.userId,
    required this.activityType,
    required this.durationMinutes,
    this.distanceKm,
    this.caloriesBurned,
    this.heartRateAvg,
    this.activityDate,
    this.notes,
    this.weatherCondition,
    this.locationData,
    this.avgPace,
    this.coinsEarned,
    this.musicPlayed,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? locationDataMap;
    if (json['location_data'] != null) {
      if (json['location_data'] is String) {
        try {
          locationDataMap = jsonDecode(json['location_data']);
        } catch (e) {
          print('ActivityModel: Error parsing location_data string: $e');
          locationDataMap = null;
        }
      } else if (json['location_data'] is Map) {
        locationDataMap = Map<String, dynamic>.from(json['location_data']);
      }
    }

    return ActivityModel(
      id: json['id'],
      userId: json['user_id'],
      activityType: json['activity_type'] ?? 'Unknown',
      durationMinutes: json['duration_minutes'] ?? 0,
      distanceKm: json['distance_km'] != null ? (json['distance_km'] as num).toDouble() : null,
      caloriesBurned: json['calories_burned'],
      heartRateAvg: json['heart_rate_avg'],
      activityDate: json['activity_date'] != null ? DateTime.parse(json['activity_date']) : null,
      notes: json['notes'],
      weatherCondition: json['weather_condition'],
      locationData: locationDataMap,
      avgPace: json['avg_pace'] != null ? (json['avg_pace'] as num).toDouble() : null,
      coinsEarned: json['coins_earned'],
      musicPlayed: json['music_played'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'activity_type': activityType,
      'duration_minutes': durationMinutes,
    };

    if (distanceKm != null) data['distance_km'] = distanceKm;
    if (caloriesBurned != null) data['calories_burned'] = caloriesBurned;
    if (heartRateAvg != null) data['heart_rate_avg'] = heartRateAvg;
    if (notes != null) data['notes'] = notes;
    if (weatherCondition != null) data['weather_condition'] = weatherCondition;
    if (locationData != null) data['location_data'] = locationData;
    if (avgPace != null) data['avg_pace'] = avgPace;
    if (musicPlayed != null) data['music_played'] = musicPlayed;

    return data;
  }
}