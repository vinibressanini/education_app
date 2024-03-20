import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/repositories/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_usecases_mock.dart';

void main() {
  late AuthRepo repo;
  late UpdateUser updateUserUsecase;

  setUp(() {
    repo = AuthRepositoryMock();
    updateUserUsecase = UpdateUser(repo);
  });

  final tUpdateUserParams = UpdateUserParams.empty();

  test(
    'WHEN [updateUser] is called successfully THEN return a Right(null)',
    () async {
      when(
        () => repo.updateUser(
          userData: tUpdateUserParams.userData,
          action: tUpdateUserParams.action,
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await updateUserUsecase(tUpdateUserParams);

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(
        () => repo.updateUser(
          userData: tUpdateUserParams.userData,
          action: tUpdateUserParams.action,
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
