import 'package:education_app/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'on_boarding_local_datasource.dart';

const kFirstTimerKey = "first_timer";

class OnBoardingLocalDatasourceImpl implements OnBoardingLocalDatasource {
  OnBoardingLocalDatasourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await _sharedPreferences.setBool(kFirstTimerKey, false);
    } on Exception catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    try {
      return _sharedPreferences.getBool(kFirstTimerKey) ?? true;
    } on Exception catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
