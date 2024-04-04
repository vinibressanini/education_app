import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/auth/data/models/local_user_model.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class SignInMock extends Mock implements SignIn {}

class SignUpMock extends Mock implements SignUp {}

class ForgotPasswordMock extends Mock implements ForgotPassword {}

class UpdateUserMock extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  final tSignInParams = SignInParams.empty();
  final tSignUpParams = SignUpParams.empty();
  final tUpdateUserParams = UpdateUserParams.empty();
  const tLocalUserModel = LocalUserModel.empty();
  final tFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  setUp(() {
    signIn = SignInMock();
    signUp = SignUpMock();
    forgotPassword = ForgotPasswordMock();
    updateUser = UpdateUserMock();
    authBloc = AuthBloc(
      forgotPassword: forgotPassword,
      signIn: signIn,
      signUp: signUp,
      updateUser: updateUser,
    );
  });

  tearDown(() => authBloc.close());

  setUpAll(() {
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tUpdateUserParams);
  });

  test('[AuthBloc] initial state SHOULD be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  group('Sign In', () {
    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, SignedIn] when [SignInEvent] is called',
      build: () {
        when(() => signIn(any())).thenAnswer(
          (_) async => const Right(
            tLocalUserModel,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignInEvent(
            email: tSignInParams.email,
            password: tSignInParams.password,
          ),
        );
      },
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
      expect: () => [const AuthLoading(), const SignedIn(tLocalUserModel)],
    );

    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, AuthError] when [SignInEvent] fails',
      build: () {
        when(() => signIn(any())).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignInEvent(
            email: tSignInParams.email,
            password: tSignInParams.password,
          ),
        );
      },
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
      expect: () => [const AuthLoading(), AuthError(tFailure.errorMessage)],
    );
  });

  group('Sign Up', () {
    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, SignedUp] when [SignUpEvent] is called',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => const Right(
            null,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            fullName: tSignUpParams.password,
          ),
        );
      },
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
      expect: () => [const AuthLoading(), const SignedUp()],
    );

    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, AuthError] when [SignUpEvent] fails',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          SignUpEvent(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            fullName: tSignUpParams.password,
          ),
        );
      },
      expect: () => [
        const AuthLoading(),
        AuthError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('Forgot Password', () {
    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, PasswordChangeEmailSent] '
      'when [ForgotPassword] is called',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => const Right(
            null,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          const ForgotPasswordEvent(
            email: 'test@email.com',
          ),
        );
      },
      verify: (_) {
        verify(() => forgotPassword(any())).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
      expect: () => [const AuthLoading(), const PasswordChangeEmailSent()],
    );

    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, AuthError] when [ForgotPassword] fails',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          const ForgotPasswordEvent(
            email: 'test@email.com',
          ),
        );
      },
      verify: (_) {
        verify(() => forgotPassword(any())).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
      expect: () => [const AuthLoading(), AuthError(tFailure.errorMessage)],
    );
  });

  group('Sign In', () {
    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, UserUpdated] when [UpdateUserEvent] is called',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Right(
            null,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            updateUserAction: tUpdateUserParams.action,
            userData: tUpdateUserParams.userData,
          ),
        );
      },
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
      expect: () => [const AuthLoading(), const UserUpdated()],
    );

    blocTest<AuthBloc, AuthState>(
      'SHOULD emit [AuthLoading, AuthError] when [UpdateUserEvent] fails',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );

        return authBloc;
      },
      act: (bloc) {
        bloc.add(
          UpdateUserEvent(
            updateUserAction: tUpdateUserParams.action,
            userData: tUpdateUserParams.userData,
          ),
        );
      },
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
      expect: () => [const AuthLoading(), AuthError(tFailure.errorMessage)],
    );
  });
}
