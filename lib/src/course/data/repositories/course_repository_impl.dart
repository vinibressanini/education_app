import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/utils/typedefs.dart';

class CourseRepositoryImpl implements CourseRepo {
  const CourseRepositoryImpl(this._datasource);

  final CourseRemoteDatasource _datasource;

  @override
  ResultFuture<void> addCourse(Course course) async {
    try {
      await _datasource.addCourse(course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Course>> getCourses() async {
    try {
      final courses = await _datasource.getCourses();
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
