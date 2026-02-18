import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../domain/entities/steps_entity.dart';
import '../../../domain/repositories/fitness_repository.dart';
import '../../../core/utils/logger.dart';

// Events
abstract class StepsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartStepTracking extends StepsEvent {}

class StepsUpdated extends StepsEvent {
  final int count;
  StepsUpdated(this.count);
  @override
  List<Object?> get props => [count];
}

class SyncStepsRequested extends StepsEvent {}

// States
abstract class StepsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StepsInitial extends StepsState {}

class StepsTracking extends StepsState {
  final int currentSteps;
  final int todaySteps;
  StepsTracking({required this.currentSteps, required this.todaySteps});
  @override
  List<Object?> get props => [currentSteps, todaySteps];
}

class StepsError extends StepsState {
  final String message;
  StepsError(this.message);
  @override
  List<Object?> get props => [message];
}

class StepsPermissionDenied extends StepsState {}

// Bloc
class StepsBloc extends Bloc<StepsEvent, StepsState> {
  final FitnessRepository repository;
  final String userId;
  StreamSubscription<StepCount>? _pedometerSubscription;

  StepsBloc({required this.repository, required this.userId})
    : super(StepsInitial()) {
    on<StartStepTracking>(_onStartTracking);
    on<StepsUpdated>(_onStepsUpdated);
    on<SyncStepsRequested>(_onSyncSteps);
  }

  Future<void> _onStartTracking(
    StartStepTracking event,
    Emitter<StepsState> emit,
  ) async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      _pedometerSubscription?.cancel();
      _pedometerSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          add(StepsUpdated(event.steps));
        },
        onError: (error) {
          AppLogger.error('Pedometer error: $error');
        },
      );
    } else {
      emit(StepsPermissionDenied());
    }
  }

  Future<void> _onStepsUpdated(
    StepsUpdated event,
    Emitter<StepsState> emit,
  ) async {
    // Logic to calculate today's steps based on initial daily reading
    // For now, just showing the raw count since boot as a placeholder
    emit(StepsTracking(currentSteps: event.count, todaySteps: event.count));

    // Auto-save locally
    await repository.saveLocalSteps(
      StepsEntity(
        id: DateTime.now().toIso8601String(),
        userId: userId,
        count: event.count,
        date: DateTime.now(),
      ),
    );
  }

  Future<void> _onSyncSteps(
    SyncStepsRequested event,
    Emitter<StepsState> emit,
  ) async {
    final localData = await repository.getLocalSteps();
    localData.fold(
      (failure) => null, // Ignore for now
      (stepsList) async {
        if (stepsList.isNotEmpty) {
          final latest = stepsList.last;
          await repository.syncSteps(latest);
        }
      },
    );
  }

  @override
  Future<void> close() {
    _pedometerSubscription?.cancel();
    return super.close();
  }
}
