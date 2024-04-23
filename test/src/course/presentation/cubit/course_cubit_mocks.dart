import 'package:education_app/src/course/domain/usecases/add_course.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:mocktail/mocktail.dart';

class AddCourseMock extends Mock implements AddCourse {}

class GetCoursesMock extends Mock implements GetCourses {}
