import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/medical_report_entity.dart';
import '../../../domain/repositories/medical_report_repository.dart';

// Events
abstract class MedicalReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExtractReportRequested extends MedicalReportEvent {
  final File image;
  ExtractReportRequested(this.image);
  @override
  List<Object?> get props => [image];
}

class SaveReportRequested extends MedicalReportEvent {
  final MedicalReportEntity report;
  SaveReportRequested(this.report);
  @override
  List<Object?> get props => [report];
}

class GetReportsRequested extends MedicalReportEvent {
  final String userId;
  GetReportsRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

// States
abstract class MedicalReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MedicalReportInitial extends MedicalReportState {}

class MedicalReportLoading extends MedicalReportState {}

class MedicalReportExtracted extends MedicalReportState {
  final MedicalReportEntity report;
  MedicalReportExtracted(this.report);
  @override
  List<Object?> get props => [report];
}

class MedicalReportSuccess extends MedicalReportState {}

class MedicalReportsLoaded extends MedicalReportState {
  final List<MedicalReportEntity> reports;
  MedicalReportsLoaded(this.reports);
  @override
  List<Object?> get props => [reports];
}

class MedicalReportError extends MedicalReportState {
  final String message;
  MedicalReportError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class MedicalReportBloc extends Bloc<MedicalReportEvent, MedicalReportState> {
  final MedicalReportRepository repository;

  MedicalReportBloc({required this.repository})
    : super(MedicalReportInitial()) {
    on<ExtractReportRequested>(_onExtract);
    on<SaveReportRequested>(_onSave);
    on<GetReportsRequested>(_onGetReports);
  }

  Future<void> _onExtract(
    ExtractReportRequested event,
    Emitter<MedicalReportState> emit,
  ) async {
    emit(MedicalReportLoading());
    final result = await repository.extractDataFromImage(event.image);
    result.fold(
      (failure) => emit(MedicalReportError(failure.message)),
      (report) => emit(MedicalReportExtracted(report)),
    );
  }

  Future<void> _onSave(
    SaveReportRequested event,
    Emitter<MedicalReportState> emit,
  ) async {
    emit(MedicalReportLoading());
    final result = await repository.saveReport(event.report);
    result.fold(
      (failure) => emit(MedicalReportError(failure.message)),
      (_) => emit(MedicalReportSuccess()),
    );
  }

  Future<void> _onGetReports(
    GetReportsRequested event,
    Emitter<MedicalReportState> emit,
  ) async {
    emit(MedicalReportLoading());
    final result = await repository.getReports(event.userId);
    result.fold(
      (failure) => emit(MedicalReportError(failure.message)),
      (reports) => emit(MedicalReportsLoaded(reports)),
    );
  }
}
