import 'package:dartz/dartz.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo_mock.dart';

void main() {
  late OnBoardingRepository onBoardingRepository;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    onBoardingRepository = OnBoardingRepoMock();
    usecase = CheckIfUserIsFirstTimer(onBoardingRepository);
  });

  test(
      'WHEN [OnBoardingRepository.CheckIfUserIsFirstTimer()] is called '
      'THEN return a Right(true) ', () async {
    when(() => onBoardingRepository.checkIfUserIsFirstTimer()).thenAnswer(
      (_) async => const Right(true),
    );

    final result = await usecase();

    expect(result, equals(const Right<void, bool>(true)));

    verify(() => onBoardingRepository.checkIfUserIsFirstTimer()).called(1);

    verifyNoMoreInteractions(onBoardingRepository);
  });
}
