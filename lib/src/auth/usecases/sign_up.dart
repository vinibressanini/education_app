import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/repositories/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  SignUp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
        fullName: params.fullName,
        email: params.email,
        password: params.password,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory SignUpParams.empty() =>
      const SignUpParams(email: '', password: '', fullName: '');

  final String email;
  final String password;
  final String fullName;

  @override
  List<String> get props => [email, password, fullName];
}
