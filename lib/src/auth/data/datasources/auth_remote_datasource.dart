import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/src/auth/data/models/local_user_model.dart';

abstract class AuthRemoteDatasource {
  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
