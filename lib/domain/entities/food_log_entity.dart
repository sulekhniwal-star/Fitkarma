import 'package:equatable/equatable.dart';

class FoodLogEntity extends Equatable {
  final String id;
  final String userId;
  final String itemName;
  final double calories;
  final Map<String, dynamic>? macros;
  final DateTime date;

  const FoodLogEntity({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.calories,
    this.macros,
    required this.date,
  });

  @override
  List<Object?> get props => [id, userId, itemName, calories, macros, date];
}
