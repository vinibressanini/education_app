import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repo.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_usecases_mock.dart';

void main() {
  late CourseRepo repo;
  late GetCourses getCoursesUsecase;

  setUp(() {
    repo = CourseRepoMock();
    getCoursesUsecase = GetCourses(repo);
  });

  test('WHEN [forgotPassword] is called successfully THEN return a Right(null)',
      () async {
    when(() => repo.getCourses()).thenAnswer((_) async => const Right([]));

    final result = await getCoursesUsecase();

    expect(result, equals(const Right<dynamic, List<Course>>([])));
    verify(() => repo.getCourses()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
