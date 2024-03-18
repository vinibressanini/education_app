import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/repositories/auth_repo.dart';
import 'package:education_app/src/auth/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_usecases_mock.dart';

void main() {
  late AuthRepo repo;
  late ForgotPassword forgotPasswordUsecase;

  setUp(() {
    repo = AuthRepositoryMock();
    forgotPasswordUsecase = ForgotPassword(repo);
  });

  test('WHEN [forgotPassword] is called successfully THEN return a Right(null)',
      () async {
    when(() => repo.forgotPassword(email: 'test@email.com'))
        .thenAnswer((_) async => const Right(null));

    final result = await forgotPasswordUsecase('test@email.com');

    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repo.forgotPassword(email: 'test@email.com')).called(1);
    verifyNoMoreInteractions(repo);
  });
}
