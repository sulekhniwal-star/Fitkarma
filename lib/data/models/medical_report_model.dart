import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/medical_report_entity.dart';

part 'medical_report_model.g.dart';

@JsonSerializable()
class MedicalReportModel extends MedicalReportEntity {
  const MedicalReportModel({
    required super.id,
    required super.userId,
    super.reportTitle,
    required super.extractedData,
    required super.date,
  });

  factory MedicalReportModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalReportModelToJson(this);

  factory MedicalReportModel.fromEntity(MedicalReportEntity entity) {
    return MedicalReportModel(
      id: entity.id,
      userId: entity.userId,
      reportTitle: entity.reportTitle,
      extractedData: entity.extractedData,
      date: entity.date,
    );
  }
}
