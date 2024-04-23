import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this._repo);

  final CourseRepo _repo;

  @override
  ResultFuture<void> call(Course params) {
    return _repo.addCourse(params);
  }
}
