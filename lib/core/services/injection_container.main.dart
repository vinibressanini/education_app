part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
}

Future<void> _initAuth() async {
  sl
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        forgotPassword: sl(),
        signIn: sl(),
        signUp: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(
        authClient: sl(),
        dbClient: sl(),
        cloudStoreClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initOnBoarding() async {
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
