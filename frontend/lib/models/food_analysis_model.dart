// lib/models/food_analysis_model.dart
// Pastikan metode toNutrientMap berfungsi dengan baik

import 'package:flutter/material.dart';

class FoodAnalysis {
  final int? id;
  final int? foodLogId;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final int fiberGrams;
  final int calories;
  final int healthinessScore;
  final double aiConfidence;
  final DateTime? analyzedAt;

  FoodAnalysis({
    this.id,
    this.foodLogId,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.fiberGrams,
    required this.calories,
    required this.healthinessScore,
    required this.aiConfidence,
    this.analyzedAt,
  });

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) {
    // Pastikan untuk menangani nilai null dan mengkonversi tipe data
    return FoodAnalysis(
      id: json['id'],
      foodLogId: json['food_log_id'],
      proteinGrams: json['protein_grams'] ?? 0, // Tambahkan default 0 jika null
      carbsGrams: json['carbs_grams'] ?? 0,
      fatGrams: json['fat_grams'] ?? 0,
      fiberGrams: json['fiber_grams'] ?? 0,
      calories: json['calories'] ?? 0,
      healthinessScore: json['healthiness_score'] ?? 0,
      aiConfidence: (json['ai_confidence'] ?? 0.0).toDouble(), // Konversi ke double
      analyzedAt: json['analyzed_at'] != null ? DateTime.parse(json['analyzed_at']) : null,
    );
  }

  // Konversi ke format untuk widget nutrient_card yang sudah diperbaiki
  Map<String, Map<String, dynamic>> toNutrientMap() {
    try {
      // Pastikan semua nilai valid untuk menghindari error
      final weightInKg = 70.0; // Berat rata-rata orang dewasa
      final dailyCalories = 2200.0; // Kalori harian rata-rata
      
      return {
        'Protein': {
          'amount': '${proteinGrams}g',
          'color': Colors.orange.shade100,
          'icon': Icons.circle_outlined,
          'perKg': '${(proteinGrams / weightInKg).toStringAsFixed(1)}g/kg',
        },
        'Carbs': {
          'amount': '${carbsGrams}g',
          'color': Colors.red.shade50,
          'icon': Icons.local_fire_department_outlined,
          'perKg': '${(carbsGrams / weightInKg).toStringAsFixed(1)}g/kg',
        },
        'Fat': {
          'amount': '${fatGrams}g',
          'color': Colors.blue.shade50,
          'icon': Icons.water_drop_outlined,
          'perKg': '${(fatGrams / weightInKg).toStringAsFixed(1)}g/kg',
        },
        'Fibers': {
          'amount': '${fiberGrams}g',
          'color': Colors.green.shade50,
          'icon': Icons.grass_outlined,
          'perKg': '${(fiberGrams / weightInKg).toStringAsFixed(1)}g/kg',
        },
        'Calories': {
          'amount': '$calories cal',
          'color': Colors.amber.shade50,
          'icon': Icons.bolt_outlined,
          'perKg': '${(calories / dailyCalories * 100).toStringAsFixed(0)}%',
        },
      };
    } catch (e) {
      print('Error in toNutrientMap: $e');
      // Fallback jika terjadi error
      return {
        'Protein': {
          'amount': '${proteinGrams}g',
          'color': Colors.orange.shade100,
          'icon': Icons.circle_outlined,
          'perKg': '-',
        },
        'Carbs': {
          'amount': '${carbsGrams}g',
          'color': Colors.red.shade50,
          'icon': Icons.local_fire_department_outlined,
          'perKg': '-',
        },
        'Fat': {
          'amount': '${fatGrams}g',
          'color': Colors.blue.shade50,
          'icon': Icons.water_drop_outlined,
          'perKg': '-',
        },
        'Fibers': {
          'amount': '${fiberGrams}g',
          'color': Colors.green.shade50,
          'icon': Icons.grass_outlined,
          'perKg': '-',
        },
        'Calories': {
          'amount': '$calories cal',
          'color': Colors.amber.shade50,
          'icon': Icons.bolt_outlined,
          'perKg': '-',
        },
      };
    }
  }
}