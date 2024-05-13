import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/domain/usecases/add_course.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_cubit_mocks.dart';

void main() {
  late AddCourse addCourse;
  late GetCourses getCourses;
  late CourseCubit cubit;

  final tCourse = CourseModel.empty();
  final tFailure =
      ServerFailure(message: 'An error ocurred', statusCode: '505');

  setUp(() {
    addCourse = AddCourseMock();
    getCourses = GetCoursesMock();
    cubit = CourseCubit(addCourse: addCourse, getCourses: getCourses);
    registerFallbackValue(tCourse);
  });

  tearDown(() => cubit.close());

  test('Initial state SHOULD be a [CourseInitial()]', () {
    expect(cubit.state, const CourseInitial());
  });

  group('addCourse', () {
    blocTest<CourseCubit, CourseState>(
      'WHEN addCourse finish successfully THEN emit [AddingCourse,CourseAdded]',
      build: () {
        when(() => addCourse(any())).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (bloc) {
        bloc.addCourse(tCourse);
      },
      expect: () => <CourseState>[
        const AddingCourse(),
        const CourseAdded(),
      ],
      verify: (_) {
        verify(() => addCourse(any())).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'WHEN addCourse returns a Left THEN emit [AddingCourse, CourseError]',
      build: () {
        when(() => addCourse(any())).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (bloc) {
        bloc.addCourse(tCourse);
      },
      expect: () => <CourseState>[
        const AddingCourse(),
        CourseError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => addCourse(any())).called(1);
        verifyNoMoreInteractions(addCourse);
      },
    );
  });
  group('getCourses', () {
    blocTest<CourseCubit, CourseState>(
      'WHEN getCourses finish successfully '
      ' THEN emit [LoadingCourses,CoursesLoaded]',
      build: () {
        final expectedResult = [tCourse];
        when(() => getCourses()).thenAnswer((_) async => Right(expectedResult));
        return cubit;
      },
      act: (bloc) {
        bloc.getCourses();
      },
      expect: () => <CourseState>[
        const LoadingCourses(),
        CoursesLoaded([tCourse]),
      ],
      verify: (bloc) {
        expect((bloc.state as CoursesLoaded).courses.length, 1);
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );

    blocTest<CourseCubit, CourseState>(
      'WHEN getCourses returns a Left'
      ' THEN emit [LoadingCourses,CourseError]',
      build: () {
        when(() => getCourses()).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (bloc) {
        bloc.getCourses();
      },
      expect: () => <CourseState>[
        const LoadingCourses(),
        CourseError(tFailure.errorMessage),
      ],
      verify: (bloc) {
        verify(() => getCourses()).called(1);
        verifyNoMoreInteractions(getCourses);
      },
    );
  });
}
