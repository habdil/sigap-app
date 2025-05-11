class HealthAssessment {
  final int screenTimeHours;
  final int exerciseHours;
  final int lateNightFrequency;
  final int dietQuality;

  HealthAssessment({
    required this.screenTimeHours, 
    required this.exerciseHours,
    required this.lateNightFrequency,
    required this.dietQuality,
  });

  Map<String, dynamic> toJson() {
    return {
      'screen_time_hours': screenTimeHours,
      'exercise_hours': exerciseHours,
      'late_night_frequency': lateNightFrequency,
      'diet_quality': dietQuality,
    };
  }

  factory HealthAssessment.fromJson(Map<String, dynamic> json) {
    return HealthAssessment(
      screenTimeHours: json['screen_time_hours'],
      exerciseHours: json['exercise_hours'],
      lateNightFrequency: json['late_night_frequency'],
      dietQuality: json['diet_quality'],
    );
  }
}

class AssessmentResult {
  final int id;
  final int userId;
  final int assessmentId;
  final int riskPercentage;
  final List<String> riskFactors;
  final List<String> recommendations;
  final String createdAt;

  AssessmentResult({
    required this.id,
    required this.userId,
    required this.assessmentId,
    required this.riskPercentage,
    required this.riskFactors,
    required this.recommendations,
    required this.createdAt,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      id: json['id'],
      userId: json['user_id'],
      assessmentId: json['assessment_id'],
      riskPercentage: json['risk_percentage'],
      riskFactors: List<String>.from(json['risk_factors']),
      recommendations: List<String>.from(json['recommendations']),
      createdAt: json['created_at'],
    );
  }
}