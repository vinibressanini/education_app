import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo_mock.dart';

void main() {
  late OnBoardingRepository onBoardingRepository;
  late CacheFirstTimer usecase;

  setUp(() {
    onBoardingRepository = OnBoardingRepoMock();
    usecase = CacheFirstTimer(onBoardingRepository);
  });

  test(
      'WHEN [OnBoardingRepository.CacheFirstTimer()] is called '
      'THEN return a Left containing a ServerFailure', () async {
    when(() => onBoardingRepository.cacheFirstTimer()).thenAnswer(
      (_) async => Left(
        ServerFailure(message: "Unknown Error Ocurred", statusCode: 500),
      ),
    );

    final result = await usecase();

    expect(
      result,
      equals(
        Left<Failure, dynamic>(
          ServerFailure(message: "Unknown Error Ocurred", statusCode: 500),
        ),
      ),
    );

    verify(() => onBoardingRepository.cacheFirstTimer()).called(1);

    verifyNoMoreInteractions(onBoardingRepository);
  });
}
