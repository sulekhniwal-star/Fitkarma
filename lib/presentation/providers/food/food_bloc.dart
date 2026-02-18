import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/food_log_entity.dart';
import '../../../domain/repositories/food_repository.dart';

// Events
abstract class FoodEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchFoodRequested extends FoodEvent {
  final String query;
  SearchFoodRequested(this.query);
  @override
  List<Object?> get props => [query];
}

class LogFoodRequested extends FoodEvent {
  final FoodLogEntity food;
  LogFoodRequested(this.food);
  @override
  List<Object?> get props => [food];
}

class GetFoodLogsRequested extends FoodEvent {
  final String userId;
  GetFoodLogsRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

// States
abstract class FoodState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodSearchSuccess extends FoodState {
  final List<FoodLogEntity> results;
  FoodSearchSuccess(this.results);
  @override
  List<Object?> get props => [results];
}

class FoodLogsSuccess extends FoodState {
  final List<FoodLogEntity> logs;
  FoodLogsSuccess(this.logs);
  @override
  List<Object?> get props => [logs];
}

class FoodError extends FoodState {
  final String message;
  FoodError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository repository;

  FoodBloc({required this.repository}) : super(FoodInitial()) {
    on<SearchFoodRequested>(_onSearchFood);
    on<LogFoodRequested>(_onLogFood);
    on<GetFoodLogsRequested>(_onGetFoodLogs);
  }

  Future<void> _onSearchFood(
    SearchFoodRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());
    final result = await repository.searchFood(event.query);
    result.fold(
      (failure) => emit(FoodError(failure.message)),
      (foods) => emit(FoodSearchSuccess(foods)),
    );
  }

  Future<void> _onLogFood(
    LogFoodRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());
    final result = await repository.logFood(event.food);
    result.fold(
      (failure) => emit(FoodError(failure.message)),
      (_) => add(GetFoodLogsRequested(event.food.userId)),
    );
  }

  Future<void> _onGetFoodLogs(
    GetFoodLogsRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(FoodLoading());
    final result = await repository.getTodayLogs(event.userId);
    result.fold(
      (failure) => emit(FoodError(failure.message)),
      (logs) => emit(FoodLogsSuccess(logs)),
    );
  }
}
