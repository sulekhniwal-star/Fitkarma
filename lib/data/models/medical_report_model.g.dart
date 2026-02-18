// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalReportModel _$MedicalReportModelFromJson(Map<String, dynamic> json) =>
    MedicalReportModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      reportTitle: json['reportTitle'] as String?,
      extractedData: json['extractedData'] as Map<String, dynamic>,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$MedicalReportModelToJson(MedicalReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'reportTitle': instance.reportTitle,
      'extractedData': instance.extractedData,
      'date': instance.date.toIso8601String(),
    };
