// lib/models/coin_transaction_model.dart

class CoinTransactionModel {
  final int? id;
  final int? userId;
  final int amount;
  final String transactionType;
  final String? referenceType;
  final int? referenceId;
  final DateTime? createdAt;

  CoinTransactionModel({
    this.id,
    this.userId,
    required this.amount,
    required this.transactionType,
    this.referenceType,
    this.referenceId,
    this.createdAt,
  });

  factory CoinTransactionModel.fromJson(Map<String, dynamic> json) {
    return CoinTransactionModel(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'] ?? 0,
      transactionType: json['transaction_type'] ?? 'Unknown',
      referenceType: json['reference_type'],
      referenceId: json['reference_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'amount': amount,
      'transaction_type': transactionType,
    };

    if (referenceType != null) data['reference_type'] = referenceType;
    if (referenceId != null) data['reference_id'] = referenceId;

    return data;
  }
}