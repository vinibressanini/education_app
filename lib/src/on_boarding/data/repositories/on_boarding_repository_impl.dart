import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_datasource.dart';

import '../../domain/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  OnBoardingRepositoryImpl(this._localDatasource);

  final OnBoardingLocalDatasource _localDatasource;

  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _localDatasource.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    // TODO: implement checkIfUserIsFirstTimer
    throw UnimplementedError();
  }
}
