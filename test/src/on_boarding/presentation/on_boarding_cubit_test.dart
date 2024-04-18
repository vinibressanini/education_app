import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubits/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CacheFirstTimerMock extends Mock implements CacheFirstTimer {}

class CheckIfUserIsFirstTimerMock extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late CacheFirstTimer cacheFirstTimer;
  late OnBoardingCubit cubit;

  setUp(() {
    checkIfUserIsFirstTimer = CheckIfUserIsFirstTimerMock();
    cacheFirstTimer = CacheFirstTimerMock();
    cubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  final tFailure = CacheFailure(message: 'Unsuficcient space', statusCode: 500);

  test('Cubit initial state MUST be an [OnBoardingInitial]', () {
    expect(cubit.state, isA<OnBoardingInitial>());
  });

  group('cacheFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'WHEN [cacheFirstTimer] is called successfully '
      'THEN emit a [CachingFirstTimer,UserCached]',
      build: () {
        when(() => cacheFirstTimer())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => const [CachingFirstTimer(), UserCached()],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'WHEN [cacheFirstTimer] is called unsuccessfully '
      'THEN emit a [CachingFirstTimer,OnBoardingError]',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () =>
          [const CachingFirstTimer(), OnBoardingError(tFailure.errorMessage)],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'WHEN [checkIfUserIsFirstTimer] is called successfully '
      'THEN emit an [CachingFirstTimer, OnBoardingStatus(false)]',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => const Right(false));

        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(isUserFirstTimer: false),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'WHEN [checkIfUserIsFirstTimer] is called unsuccessfully '
      'THEN emit an [CachingFirstTimer, OnBoardingStatus(true)]',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => Left(tFailure));

        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => const [
        CheckingIfUserIsFirstTimer(),
        OnBoardingStatus(isUserFirstTimer: true),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
