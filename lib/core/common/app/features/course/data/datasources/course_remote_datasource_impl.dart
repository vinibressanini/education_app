import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/app/features/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/app/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/app/features/course/domain/entities/course.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CourseRemoteDatasourceImpl implements CourseRemoteDatasource {
  const CourseRemoteDatasourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore dbClient,
    required FirebaseStorage storage,
  })  : _auth = auth,
        _dbClient = dbClient,
        _storage = storage;

  final FirebaseFirestore _dbClient;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  @override
  Future<void> addCourse(Course course) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw const ServerException(
          message: "User isn't authenticated",
          statusCode: '401',
        );
      }

      final courseRef = _dbClient.collection('courses').doc();
      final groupRef = _dbClient.collection('groups').doc();

      var courseModel = (course as CourseModel).copyWith(
        id: courseRef.id,
        groupId: groupRef.id,
      );

      if (courseModel.imageIsFile) {
        final storageRef = _storage.ref().child(
              'courses/${courseModel.id}/profile-image/${courseModel.title}-pfp',
            );

        await storageRef.putFile(File(courseModel.image!)).then((value) async {
          final url = await value.ref.getDownloadURL();
          courseModel = courseModel.copyWith(image: url);
        });
      }

      await courseRef.set(courseModel.toMap());

      final groupModel = Group(
        id: groupRef.id,
        name: courseModel.title,
        courseId: courseModel.id,
        members: const [],
        groupImageUrl: courseModel.image,
      );

      await groupRef.set(groupModel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'An unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw const ServerException(
          message: "User isn't authenticated",
          statusCode: '401',
        );
      }

      return _dbClient.collection('courses').get().then((value) {
        return value.docs.map((course) {
          return CourseModel.fromMap(course.data());
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'An unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
