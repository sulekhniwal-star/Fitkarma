/// Karma transaction model for tracking earned and spent points
class KarmaTransaction {
  final String id;
  final String userId;
  final int amount;
  final String actionType;
  final String? description;
  final DateTime date;

  KarmaTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.actionType,
    this.description,
    required this.date,
  });

  factory KarmaTransaction.fromJson(Map<String, dynamic> json) {
    return KarmaTransaction(
      id: json['id'] as String,
      userId: (json['user'] ?? json['userId']) as String,
      amount: json['amount'] as int,
      actionType: json['action_type'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'amount': amount,
      'action_type': actionType,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  KarmaTransaction copyWith({
    String? id,
    String? userId,
    int? amount,
    String? actionType,
    String? description,
    DateTime? date,
  }) {
    return KarmaTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      actionType: actionType ?? this.actionType,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
