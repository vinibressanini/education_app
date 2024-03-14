import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';

class CacheFirstTimer implements UsecaseWithoutParams<void> {
  CacheFirstTimer(this._repo);

  final OnBoardingRepository _repo;

  @override
  ResultFuture<void> call() => _repo.cacheFirstTimer();
}
