import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/medical_report_entity.dart';
import '../../domain/repositories/medical_report_repository.dart';
import '../models/medical_report_model.dart';
import '../../core/utils/logger.dart';

class MedicalReportRepositoryImpl implements MedicalReportRepository {
  final PocketBase pb;
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  MedicalReportRepositoryImpl({required this.pb});

  @override
  Future<Either<Failure, MedicalReportEntity>> extractDataFromImage(
    File imageFile,
  ) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      final String text = recognizedText.text;
      AppLogger.info('OCR Extracted Text: $text');

      // Simple parsing logic (MVP)
      final extractedData = _parseVitals(text);

      final report = MedicalReportEntity(
        id: DateTime.now().toIso8601String(),
        userId: '', // To be filled by Bloc
        reportTitle: 'Extracted Report',
        extractedData: extractedData,
        date: DateTime.now(),
      );

      return Right(report);
    } catch (e, stack) {
      AppLogger.error('OCR Extraction failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }

  Map<String, dynamic> _parseVitals(String text) {
    Map<String, dynamic> vitals = {};

    // Example: Searching for common vital patterns
    // BP: 120/80
    final bpRegex = RegExp(r'(\d{2,3})/(\d{2,3})');
    final bpMatch = bpRegex.firstMatch(text);
    if (bpMatch != null) {
      vitals['blood_pressure'] = bpMatch.group(0);
    }

    // Glucose: 110 mg/dl
    final glucoseRegex = RegExp(r'Glucose[:\s]+(\d+)', caseSensitive: false);
    final glucoseMatch = glucoseRegex.firstMatch(text);
    if (glucoseMatch != null) {
      vitals['glucose'] = glucoseMatch.group(1);
    }

    // Weight: 70kg
    final weightRegex = RegExp(
      r'Weight[:\s]+(\d+\.?\d*)',
      caseSensitive: false,
    );
    final weightMatch = weightRegex.firstMatch(text);
    if (weightMatch != null) {
      vitals['weight'] = weightMatch.group(1);
    }

    return vitals;
  }

  @override
  Future<Either<Failure, void>> saveReport(MedicalReportEntity report) async {
    try {
      final body = {
        "user": report.userId,
        "title": report.reportTitle,
        "data": report.extractedData,
        "date": report.date.toIso8601String(),
      };
      await pb.collection('medical_reports').create(body: body);
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error('Saving medical report failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MedicalReportEntity>>> getReports(
    String userId,
  ) async {
    try {
      final records = await pb
          .collection('medical_reports')
          .getList(filter: 'user = "$userId"', sort: '-date');
      final reports = records.items
          .map((r) => MedicalReportModel.fromJson(r.toJson()))
          .toList();
      return Right(reports);
    } catch (e, stack) {
      AppLogger.error('Fetching medical reports failed', e, stack);
      return Left(ServerFailure(e.toString()));
    }
  }
}
