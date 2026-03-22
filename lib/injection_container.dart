import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network/dio_client.dart';
import 'core/network/xtream_data_source.dart';
import 'core/network/local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/presentation/bloc/movie_bloc.dart';
import 'features/series/data/repositories/series_repository_impl.dart';
import 'features/series/domain/repositories/series_repository.dart';
import 'features/series/presentation/bloc/series_bloc.dart';
import 'features/player/presentation/bloc/player_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/profile/data/models/profile_model.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(ProfileModelAdapter());
  
  // Open Hive boxes
  final settingsBox = await Hive.openBox<String>('settings');
  final profilesBox = await Hive.openBox<ProfileModel>('profiles');
  final watchProgressBox = await Hive.openBox<Map>('watch_progress');
  
  // Register Hive boxes
  sl.registerLazySingleton<Box<String>>(() => settingsBox);
  sl.registerLazySingleton<Box<ProfileModel>>(() => profilesBox);
  sl.registerLazySingleton<Box<Map>>(() => watchProgressBox);
  
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  
  // Data Sources
  sl.registerLazySingleton<XtreamDataSource>(
    () => XtreamDataSourceImpl(sl()),
  );
  
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(
      settingsBox: sl(),
      profilesBox: sl(),
      watchProgressBox: sl(),
    ),
  );
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      xtreamDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(localDataSource: sl()),
  );
  
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(xtreamDataSource: sl()),
  );
  
  sl.registerLazySingleton<SeriesRepository>(
    () => SeriesRepositoryImpl(xtreamDataSource: sl()),
  );
  
  // BLoCs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: sl()),
  );
  
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(profileRepository: sl()),
  );
  
  sl.registerFactory<MovieBloc>(
    () => MovieBloc(movieRepository: sl()),
  );
  
  sl.registerFactory<SeriesBloc>(
    () => SeriesBloc(seriesRepository: sl()),
  );
  
  sl.registerFactory<PlayerBloc>(
    () => PlayerBloc(),
  );
  
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(),
  );
}
