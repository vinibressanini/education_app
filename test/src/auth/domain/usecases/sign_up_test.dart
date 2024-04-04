import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/repositories/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_usecases_mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp signUpUsecase;

  setUp(() {
    repo = AuthRepositoryMock();
    signUpUsecase = SignUp(repo);
  });

  final tSignUpParams = SignUpParams.empty();

  test('WHEN [signUp] is called successfully THEN return a Right(null)',
      () async {
    when(
      () => repo.signUp(
        fullName: any(named: 'fullName'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await signUpUsecase(tSignUpParams);

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repo.signUp(
        fullName: tSignUpParams.fullName,
        email: tSignUpParams.email,
        password: tSignUpParams.password,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
