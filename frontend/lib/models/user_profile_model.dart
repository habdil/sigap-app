class UserProfile {
  final int? age;
  final double? height; // in cm
  final double? weight; // in kg

  UserProfile({
    this.age,
    this.height,
    this.weight,
  });

  bool get isComplete => age != null && height != null && weight != null;

  UserProfile copyWith({
    int? age,
    double? height,
    double? weight,
  }) {
    return UserProfile(
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
    );
  }
}