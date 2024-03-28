import 'package:bloc/bloc.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required ForgotPassword forgotPassword,
    required SignIn signIn,
    required SignUp signUp,
    required UpdateUser updateUser,
  })  : _forgotPassword = forgotPassword,
        _signIn = signIn,
        _signUp = signUp,
        _updateUser = updateUser,
        super(const AuthInitial()) {
    on<ForgotPasswordEvent>((event, emit) {
      emit(const AuthLoading());

      // TODO(auth-bloc): implement event handler
    });
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;
}
