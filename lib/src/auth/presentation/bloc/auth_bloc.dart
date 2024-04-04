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
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInEventHandler);
    on<SignUpEvent>(_signUpEventHandler);
    on<ForgotPasswordEvent>(_forgotPasswordEventHandler);
    on<UpdateUserEvent>(_updateUserEventHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;

  Future<void> _signInEventHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(
        AuthError(failure.errorMessage),
      ),
      (user) => emit(
        SignedIn(user),
      ),
    );
  }

  Future<void> _signUpEventHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );

    result.fold(
      (failure) => emit(
        AuthError(failure.errorMessage),
      ),
      (success) => emit(
        const SignedUp(),
      ),
    );
  }

  Future<void> _forgotPasswordEventHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(
      event.email,
    );

    result.fold(
      (failure) => emit(
        AuthError(failure.errorMessage),
      ),
      (success) => emit(
        const PasswordChangeEmailSent(),
      ),
    );
  }

  Future<void> _updateUserEventHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        userData: event.userData,
        action: event.updateUserAction,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (success) => emit(const UserUpdated()),
    );
  }
}
