import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/app/features/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/app/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/app/features/course/data/repositories/course_repository_impl.dart';
import 'package:education_app/core/common/app/features/course/domain/entities/course.dart';
import 'package:education_app/core/common/app/features/course/domain/repositories/course_repo.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CourseRemoteDatasourceMock extends Mock
    implements CourseRemoteDatasource {}

void main() {
  late CourseRemoteDatasource datasource;
  late CourseRepo repo;
  final tCourse = CourseModel.empty();
  const tException = ServerException(
    message: 'An unknown error occurred',
    statusCode: 'server-failure',
  );

  setUp(() {
    datasource = CourseRemoteDatasourceMock();
    repo = CourseRepositoryImpl(datasource);
    registerFallbackValue(tCourse);
  });

  group('addCourse', () {
    test('SHOULD finish successfully WHEN no Exception is thrown', () async {
      when(() => datasource.addCourse(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repo.addCourse(tCourse);

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => datasource.addCourse(any())).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('SHOULD return a [Left(ServerFailure)] when an exception is thrown',
        () async {
      when(() => datasource.addCourse(any())).thenThrow(tException);

      final result = await repo.addCourse(tCourse);

      expect(
        result,
        equals(
          Left<ServerFailure, void>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(() => datasource.addCourse(any())).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('getCourses', () {
    test('SHOULD return a [Right(List<Course>)] when no exception is thrown',
        () async {
      when(() => datasource.getCourses()).thenAnswer((_) async => [tCourse]);

      final result = await repo.getCourses();

      expect(result, isA<Right<dynamic, List<Course>>>());
      verify(() => datasource.getCourses()).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('SHOULD return a [Left(ServerFailure)] when an exception is thrown',
        () async {
      when(() => datasource.getCourses()).thenThrow(tException);

      final result = await repo.getCourses();

      expect(
        result,
        equals(
          Left<ServerFailure, void>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );

      verify(() => datasource.getCourses()).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
