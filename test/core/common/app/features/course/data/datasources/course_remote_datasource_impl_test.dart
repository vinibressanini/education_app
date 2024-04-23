import 'package:education_app/core/common/app/features/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/core/common/app/features/course/data/datasources/course_remote_datasource_impl.dart';
import 'package:education_app/core/common/app/features/course/data/models/course_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;
  late FakeFirebaseFirestore firestore;
  late CourseRemoteDatasource datasource;

  final tCourse = CourseModel.empty();

  setUp(() async {
    final userMock = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'display name',
    );

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;

    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: userMock);

    await auth.signInWithCredential(credentials);

    storage = MockFirebaseStorage();
    firestore = FakeFirebaseFirestore();

    datasource = CourseRemoteDatasourceImpl(
      auth: auth,
      dbClient: firestore,
      storage: storage,
    );
  });

  group('add course', () {
    test('SHOULD add the given course to the firestore collection', () async {
      await datasource.addCourse(tCourse);

      final courseData = await firestore.collection('course').get();
      expect(courseData.docs.length, 1);

      final courseRef = courseData.docs.first;
      expect(courseRef.data()['id'], courseRef.id);

      final groupData = await firestore.collection('group').get();
      expect(groupData.docs.length, 1);

      final groupRef = groupData.docs.first;
      expect(groupRef.data()['id'], groupRef.id);

      expect(courseRef.data()['groupId'], groupRef.id);
      expect(groupRef.data()['courseId'], courseRef.id);
    });
  });
}
