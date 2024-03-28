import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';

abstract class AuthRepo {
  ResultFuture<void> forgotPassword({required String email});

  ResultFuture<LocalUser> singIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  ResultFuture<void> updateUser({
    required dynamic userData,
    required UpdateUserAction action,
  });
}
