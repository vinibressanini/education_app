import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/domain/entities/course.dart';

abstract class CourseRemoteDatasource {
  const CourseRemoteDatasource();

  Future<List<CourseModel>> getCourses();
  Future<void> addCourse(Course course);
}
