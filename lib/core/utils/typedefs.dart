import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';

typedef ResultFuture<T> = Either<Failure, T>;
