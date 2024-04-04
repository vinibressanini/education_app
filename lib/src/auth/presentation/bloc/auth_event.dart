part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<dynamic> get props => [];
}

final class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent({required this.email});

  final String email;

  @override
  List<String> get props => [email];
}

final class SignInEvent extends AuthEvent {
  const SignInEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}

final class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.fullName,
  });

  final String email;
  final String password;
  final String fullName;

  @override
  List<String> get props => [email, password, fullName];
}

final class UpdateUserEvent extends AuthEvent {
  const UpdateUserEvent({
    required this.updateUserAction,
    required this.userData,
  });

  final UpdateUserAction updateUserAction;
  final dynamic userData;

  @override
  List<dynamic> get props => [updateUserAction, userData];
}
