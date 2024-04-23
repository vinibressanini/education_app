import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/common/app/features/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/app/features/course/data/models/course_model.dart';
import 'package:education_app/core/common/app/features/course/domain/entities/course.dart';
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
  Future<void> addCourse(Course course) {
    // TODO: implement addCourse
    throw UnimplementedError();
  }

  @override
  Future<List<CourseModel>> getCourses() {
    // TODO: implement getCourses
    throw UnimplementedError();
  }
}
