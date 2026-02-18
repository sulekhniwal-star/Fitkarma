import 'package:equatable/equatable.dart';

class StepsEntity extends Equatable {
  final String id;
  final String userId;
  final int count;
  final DateTime date;

  const StepsEntity({
    required this.id,
    required this.userId,
    required this.count,
    required this.date,
  });

  @override
  List<Object?> get props => [id, userId, count, date];
}
