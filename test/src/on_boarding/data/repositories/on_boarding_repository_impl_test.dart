import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_datasource.dart';
import 'package:education_app/src/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class OnBoardingLocalDatasourceMock extends Mock
    implements OnBoardingLocalDatasource {}

void main() {
  late OnBoardingLocalDatasource localDatasource;
  late OnBoardingRepositoryImpl repo;

  setUp(() {
    localDatasource = OnBoardingLocalDatasourceMock();
    repo = OnBoardingRepositoryImpl(localDatasource);
  });

  test('[repo] should be a subclass of [OnBoardingRepository]', () {
    expect(repo, isA<OnBoardingRepository>());
  });
  group('cacheFirstTimer tests', () {
    test(
        'WHEN [localDatasource.cacheFirstTimer()] call is successfull '
        'THEN return a [Rigth(null)]', () async {
      when(() => localDatasource.cacheFirstTimer())
          .thenAnswer((_) async => Future.value());

      final result = await repo.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => localDatasource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test(
        'WHEN [localDatasource.cacheFirstTimer()] call is unsuccessfull '
        ' THEN return a [Left(CacheFailure)]', () async {
      when(() => localDatasource.cacheFirstTimer())
          .thenThrow(const CacheException(message: 'Insufficient storage'));

      final result = await repo.cacheFirstTimer();

      expect(
        result,
        equals(
          Left<CacheFailure, void>(
            CacheFailure(message: 'Insufficient storage', statusCode: 500),
          ),
        ),
      );
      verify(() => localDatasource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });
  });

  group('checkIfUserIsFirstTimer', () {
    test('MUST return a [Right(true)] if the user is first timer', () async {
      when(() => localDatasource.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => true);

      final result = await repo.checkIfUserIsFirstTimer();

      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => localDatasource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('MUST return a Right(false) if the user is not a first timer',
        () async {
      when(() => localDatasource.checkIfUserIsFirstTimer())
          .thenAnswer((_) async => false);

      final result = await repo.checkIfUserIsFirstTimer();

      expect(result, equals(const Right<dynamic, bool>(false)));
      verify(() => localDatasource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test(
        'MUST return a Left(CacheFailure) '
        'if the datasource call is unsuccessful', () async {
      when(() => localDatasource.checkIfUserIsFirstTimer()).thenThrow(
        const CacheException(message: 'Insufficient storage'),
      );

      final result = await repo.checkIfUserIsFirstTimer();

      expect(
        result,
        equals(
          Left<CacheFailure, dynamic>(
            CacheFailure(message: 'Insufficient storage', statusCode: 500),
          ),
        ),
      );
      verify(() => localDatasource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });
  });
}
