import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';

class CheckIfUserIsFirstTimer extends UsecaseWithoutParams<bool> {
  CheckIfUserIsFirstTimer(this._repo);

  final OnBoardingRepository _repo;

  @override
  ResultFuture<bool> call() => _repo.checkIfUserIsFirstTimer();
}
