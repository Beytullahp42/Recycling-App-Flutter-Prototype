class TransactionModel {
  final int id;
  final int amount;
  final String reason;
  final String type;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.reason,
    required this.type,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'],
      reason: json['reason'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
