import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/workout_entity.dart';
import '../../../domain/repositories/workout_repository.dart';

// Events
abstract class WorkoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogWorkoutRequested extends WorkoutEvent {
  final WorkoutEntity workout;
  LogWorkoutRequested(this.workout);
  @override
  List<Object?> get props => [workout];
}

class GetWorkoutsRequested extends WorkoutEvent {
  final String userId;
  GetWorkoutsRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

// States
abstract class WorkoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutSuccess extends WorkoutState {}

class WorkoutsLoaded extends WorkoutState {
  final List<WorkoutEntity> workouts;
  WorkoutsLoaded(this.workouts);
  @override
  List<Object?> get props => [workouts];
}

class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository repository;

  WorkoutBloc({required this.repository}) : super(WorkoutInitial()) {
    on<LogWorkoutRequested>(_onLogWorkout);
    on<GetWorkoutsRequested>(_onGetWorkouts);
  }

  Future<void> _onLogWorkout(
    LogWorkoutRequested event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await repository.logWorkout(event.workout);
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (_) => emit(WorkoutSuccess()),
    );
  }

  Future<void> _onGetWorkouts(
    GetWorkoutsRequested event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    final result = await repository.getWorkouts(event.userId);
    result.fold(
      (failure) => emit(WorkoutError(failure.message)),
      (workouts) => emit(WorkoutsLoaded(workouts)),
    );
  }
}
