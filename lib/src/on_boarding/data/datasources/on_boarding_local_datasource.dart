abstract class OnBoardingLocalDatasource {
  OnBoardingLocalDatasource();

  Future<void> cacheFirstTimer();
  Future<bool> checkIfUserIsFirstTimer();
}
