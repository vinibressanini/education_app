import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/repositories/auth_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  UpdateUser(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(UpdateUserParams params) => _repo.updateUser(
        userData: params.userData,
        action: params.action,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.userData,
    required this.action,
  });

  factory UpdateUserParams.empty() => const UpdateUserParams(
        userData: '',
        action: UpdateUserAction.displsyName,
      );

  final dynamic userData;
  final UpdateUserAction action;

  @override
  List<dynamic> get props => [userData, action];
}
