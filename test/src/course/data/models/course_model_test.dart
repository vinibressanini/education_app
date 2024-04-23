import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 154156,
    '_nanoseconds': 56165135,
  };

  final date = DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!)
      .add(Duration(microseconds: timestampData['_nanoseconds']!));

  final timestamp = Timestamp.fromDate(date);

  final tCourseModel = CourseModel.empty();

  final tMap = jsonDecode(fixture('course.json')) as DataMap;

  tMap['createdAt'] = timestamp;
  tMap['updatedAt'] = timestamp;

  test('SHOULD be a subclass of [Course]', () {
    expect(tCourseModel, isA<Course>());
  });

  group('empty', () {
    test('.empty SHOULD return a empty CourseModel', () {
      final emptyModel = CourseModel.empty();

      expect(emptyModel.id, 'id');
    });
  });

  group('fromMap', () {
    test('fromMap SHOULD return a [CourseModel] based on the given map', () {
      final courseModel = CourseModel.fromMap(tMap);

      expect(courseModel, isA<CourseModel>());

      expect(courseModel.title, 'title');
      expect(courseModel, equals(tCourseModel));
    });
  });

  group('toMap', () {
    test('toMap SHOULD return a [DatMap] based on the given [CourseModel]', () {
      final result = tCourseModel.toMap()
        ..remove('createdAt')
        ..remove('updatedAt');

      final map = DataMap.from(tMap)
        ..remove('createdAt')
        ..remove('updatedAt');

      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('copyWith SHOULD create a new [CourseModel] with the new data', () {
      final model = tCourseModel.copyWith(title: 'copy with model');

      expect(model.title, equals('copy with model'));
      expect(model.id, equals('id'));
    });
  });
}
