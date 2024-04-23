import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';

class GetCourses extends UsecaseWithoutParams<List<Course>> {
  const GetCourses(this._repo);

  final CourseRepo _repo;

  @override
  ResultFuture<List<Course>> call() {
    return _repo.getCourses();
  }
}
