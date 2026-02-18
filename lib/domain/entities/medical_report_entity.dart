import 'package:equatable/equatable.dart';

class MedicalReportEntity extends Equatable {
  final String id;
  final String userId;
  final String? reportTitle;
  final Map<String, dynamic> extractedData;
  final DateTime date;

  const MedicalReportEntity({
    required this.id,
    required this.userId,
    this.reportTitle,
    required this.extractedData,
    required this.date,
  });

  @override
  List<Object?> get props => [id, userId, reportTitle, extractedData, date];
}
