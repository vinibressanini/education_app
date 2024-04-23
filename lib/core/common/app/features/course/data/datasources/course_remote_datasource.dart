import 'package:education_app/core/common/app/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/app/features/course/domain/entities/course.dart';

abstract class CourseRemoteDatasource {
  const CourseRemoteDatasource();

  Future<List<CourseModel>> getCourses();
  Future<void> addCourse(Course course);
}
