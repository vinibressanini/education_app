import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';
import 'package:education_app/src/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  ResultFuture<void> forgotPassword({required String email}) async {
    try {
      await _datasource.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      await _datasource.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<LocalUser> singIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _datasource.signIn(email: email, password: password);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<void> updateUser({
    required dynamic userData,
    required UpdateUserAction action,
  }) async {
    try {
      await _datasource.updateUser(action: action, userData: userData);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
