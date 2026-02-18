import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/errors/failure.dart';
import '../entities/medical_report_entity.dart';

abstract class MedicalReportRepository {
  Future<Either<Failure, MedicalReportEntity>> extractDataFromImage(
    File imageFile,
  );
  Future<Either<Failure, void>> saveReport(MedicalReportEntity report);
  Future<Either<Failure, List<MedicalReportEntity>>> getReports(String userId);
}
