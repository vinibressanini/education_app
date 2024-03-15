import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_datasource.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_datasource_impl.dart';
import 'package:education_app/src/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubits/cubit/on_boarding_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  sl
    ..registerFactory<OnBoardingCubit>(() {
      return OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      );
    })
    ..registerLazySingleton<CacheFirstTimer>(
      () => CacheFirstTimer(sl()),
    )
    ..registerLazySingleton<CheckIfUserIsFirstTimer>(
      () => CheckIfUserIsFirstTimer(sl()),
    )
    ..registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(sl()),
    )
    ..registerLazySingleton<OnBoardingLocalDatasource>(
      () => OnBoardingLocalDatasourceImpl(prefs),
    );
}
