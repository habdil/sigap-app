// lib/models/food_model.dart
import 'package:frontend/models/food_analysis_model.dart';

class FoodLog {
  final int? id;
  final int? userId;
  final String foodName;
  final DateTime? logDate;
  final String? notes;
  final FoodAnalysis? analysis;

  FoodLog({
    this.id,
    this.userId,
    required this.foodName,
    this.logDate,
    this.notes,
    this.analysis,
  });

  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'],
      userId: json['user_id'],
      foodName: json['food_name'] ?? 'Unknown Food', // Tambahkan default value
      logDate: json['log_date'] != null ? DateTime.parse(json['log_date']) : null,
      notes: json['notes'],
      analysis: json['analysis'] != null ? FoodAnalysis.fromJson(json['analysis']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'notes': notes,
    };
  }
}