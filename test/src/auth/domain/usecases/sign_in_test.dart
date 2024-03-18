import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';
import 'package:education_app/src/auth/repositories/auth_repo.dart';
import 'package:education_app/src/auth/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_usecases_mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn signInUsecase;

  setUp(() {
    repo = AuthRepositoryMock();
    signInUsecase = SignIn(repo);
  });

  final tSignInParams = SignInParams.empty();
  final tUser = LocalUser.empty();

  test('WHEN [signIn] is called successful THEN return a Right(LocalUser)',
      () async {
    when(
      () => repo.singIn(
        email: tSignInParams.email,
        password: tSignInParams.password,
      ),
    ).thenAnswer(
      (_) async => Right(
        tUser,
      ),
    );

    final result = await signInUsecase(tSignInParams);

    expect(result, equals(Right<dynamic, LocalUser>(tUser)));

    verify(
      () => repo.singIn(
        email: tSignInParams.email,
        password: tSignInParams.password,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
