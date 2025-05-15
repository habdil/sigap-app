// lib/models/coin_model.dart

class CoinModel {
  final int? id;
  final int? userId;
  final int totalCoins;
  final DateTime? updatedAt;

  CoinModel({
    this.id,
    this.userId,
    required this.totalCoins,
    this.updatedAt,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      userId: json['user_id'],
      totalCoins: json['total_coins'] ?? 0,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}