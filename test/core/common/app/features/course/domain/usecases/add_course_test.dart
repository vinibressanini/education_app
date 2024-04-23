import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/app/features/course/domain/entities/course.dart';
import 'package:education_app/core/common/app/features/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/common/app/features/course/domain/usecases/add_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_usecases_mock.dart';

void main() {
  late CourseRepo repo;
  late AddCourse addCourseUsecase;

  setUp(() {
    repo = CourseRepoMock();
    addCourseUsecase = AddCourse(repo);
  });

  final tCourse = Course.empty();

  test('WHEN [forgotPassword] is called successfully THEN return a Right(null)',
      () async {
    when(() => repo.addCourse(tCourse))
        .thenAnswer((_) async => const Right(null));

    final result = await addCourseUsecase(tCourse);

    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repo.addCourse(tCourse)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
