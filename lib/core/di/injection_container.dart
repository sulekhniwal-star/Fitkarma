import 'package:fit_karma/data/repositories/workout_repository_impl.dart';
import 'package:fit_karma/domain/repositories/workout_repository.dart';
import 'package:fit_karma/presentation/providers/workout/workout_bloc.dart';
import 'package:fit_karma/data/repositories/medical_report_repository_impl.dart';
import 'package:fit_karma/domain/repositories/medical_report_repository.dart';
import 'package:fit_karma/presentation/providers/medical/medical_report_bloc.dart';
import 'package:fit_karma/presentation/providers/food/food_bloc.dart';
import 'package:fit_karma/data/repositories/food_repository_impl.dart';
import 'package:fit_karma/domain/repositories/food_repository.dart';
import 'package:fit_karma/data/repositories/fitness_repository_impl.dart';
import 'package:fit_karma/domain/repositories/fitness_repository.dart';
import 'package:fit_karma/data/models/steps_model.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';
import 'package:fit_karma/data/datasources/remote/auth_remote_datasource.dart';
import 'package:fit_karma/data/repositories/auth_repository_impl.dart';
import 'package:fit_karma/domain/repositories/auth_repository.dart';
import 'package:fit_karma/domain/usecases/auth/auth_usecases.dart';
import 'package:fit_karma/presentation/providers/auth/auth_bloc.dart';

final sl = GetIt.instance; // sl is short for Service Locator

Future<void> init() async {
  //! Features - Authentication
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  //! Features - Fitness
  // Repository
  sl.registerLazySingleton<FitnessRepository>(
    () => FitnessRepositoryImpl(
      pb: sl(),
      stepsBox: Hive.box<StepsModel>('steps'),
    ),
  );

  // Bloc
  sl.registerFactory(() => FoodBloc(repository: sl()));
  sl.registerFactory(() => MedicalReportBloc(repository: sl()));
  sl.registerFactory(() => WorkoutBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<FoodRepository>(() => FoodRepositoryImpl(pb: sl()));
  sl.registerLazySingleton<MedicalReportRepository>(
    () => MedicalReportRepositoryImpl(pb: sl()),
  );
  sl.registerLazySingleton<WorkoutRepository>(
    () => WorkoutRepositoryImpl(pb: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // PocketBase Client
  // Replace with your Railway URL or local IP for testing
  const baseUrl = 'http://127.0.0.1:8080';
  sl.registerLazySingleton(() => PocketBase(baseUrl));

  AppLogger.info('Dependency Injection initialized');
}
