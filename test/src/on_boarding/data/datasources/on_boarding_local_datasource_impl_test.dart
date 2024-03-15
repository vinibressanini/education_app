import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {}

void main() {
  late OnBoardingLocalDatasourceImpl localDatasource;
  late SharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = SharedPreferencesMock();
    localDatasource = OnBoardingLocalDatasourceImpl(sharedPreferences);
  });

  group('cacheFirstTimer', () {
    test('MUST call [SharedPreferences] to cache the data', () async {
      when(() => sharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      await localDatasource.cacheFirstTimer();

      verify(() => sharedPreferences.setBool(kFirstTimerKey, false));
      verifyNoMoreInteractions(sharedPreferences);
    });

    test(
        'WHEN an error occurs while caching the data'
        ' THEN throw a [CacheException] ', () async {
      when(() => sharedPreferences.setBool(any(), any()))
          .thenThrow(Exception());

      final methodCall = localDatasource.cacheFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));
      verify(() => sharedPreferences.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  group('checkIfUserIsFirstTimer', () {
    test(
        'MUST call [SharedPreferences] to check id the user is first timer and '
        'return the right data if the it exists', () async {
      when(() => sharedPreferences.getBool(any())).thenReturn(true);

      final result = await localDatasource.checkIfUserIsFirstTimer();

      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      expect(result, true);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('MUST return true when there is no data cached', () async {
      when(() => sharedPreferences.getBool(any())).thenReturn(null);

      final result = await localDatasource.checkIfUserIsFirstTimer();

      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      expect(result, true);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test(
        'MUST throw a [CacheException] when a error occurs while '
        'retrieving the cached data', () async {
      when(() => sharedPreferences.getBool(any())).thenThrow(Exception());

      final methodCall = localDatasource.checkIfUserIsFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));
      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });
  });
}
