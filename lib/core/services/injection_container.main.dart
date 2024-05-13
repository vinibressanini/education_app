part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
  await _initCourse();
}

Future<void> _initCourse() async {
  sl
    ..registerFactory<CourseCubit>(
      () => CourseCubit(
        addCourse: sl(),
        getCourses: sl(),
      ),
    )
    ..registerLazySingleton<AddCourse>(() => AddCourse(sl()))
    ..registerLazySingleton<GetCourses>(() => GetCourses(sl()))
    ..registerLazySingleton<CourseRepo>(() => CourseRepositoryImpl(sl()))
    ..registerLazySingleton<CourseRemoteDatasource>(
      () => CourseRemoteDatasourceImpl(
        auth: sl(),
        dbClient: sl(),
        storage: sl(),
      ),
    );
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
      () => OnBoardingLocalDatasourceImpl(sl()),
    )
    ..registerLazySingleton<SharedPreferences>(() => prefs);
}
