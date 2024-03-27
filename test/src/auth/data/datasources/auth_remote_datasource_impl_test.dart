import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:education_app/src/auth/data/models/local_user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tEmail = 'Test email';
  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );
  const tUser = LocalUserModel.empty();

  late FirebaseAuth authClient;
  late User user;
  // late AuthCredential authCredential;
  late UserCredential userCredential;
  late DocumentReference<DataMap> docReference;
  late FakeFirebaseFirestore cloudStoreClient;
  late AuthRemoteDatasource datasource;
  late MockFirebaseStorage dbClient;

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    docReference = cloudStoreClient.collection('users').doc();
    await docReference.set(
      tUser.copyWith(uid: docReference.id).toMap(),
    );
    dbClient = MockFirebaseStorage();
    user = MockUser()..uid = docReference.id;
    userCredential = MockUserCredential(user);
    datasource = AuthRemoteDatasourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );

    when(() => authClient.currentUser).thenReturn(user);
  });

  group('forgot password', () {
    test('should complete successfully when no [Exception] is thrown',
        () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenAnswer((_) async => Future.value());

      final result = datasource.forgotPassword(tEmail);

      expect(result, completes);

      verify(
        () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });

    test(
        'should throw a [ServerException] '
        'when a [FirebaseAuthException] occurs', () async {
      when(() => authClient.sendPasswordResetEmail(email: any(named: 'email')))
          .thenThrow(tFirebaseAuthException);

      final call = datasource.forgotPassword;

      expect(() => call(tEmail), throwsA(isA<ServerException>()));

      verify(
        () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });
  });

  group('sign in', () {
    test('should return [LocalUserModel] when no [Exception] is thrown',
        () async {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => userCredential,
      );

      final user = await datasource.signIn(
        email: tEmail,
        password: tPassword,
      );

      expect(user, isNotNull);
      expect(user, isA<LocalUserModel>());
      expect(user.points, 0);
      expect(user.uid, userCredential.user!.uid);
      verify(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);

      verifyNoMoreInteractions(authClient);
    });

    test(
      'should throw [ServerException] when user is null after signing in',
      () async {
        final emptyUserCredential = MockUserCredential();

        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => emptyUserCredential);

        final methodCall = datasource.signIn;

        expect(
          () => methodCall(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);

        verifyNoMoreInteractions(authClient);
      },
    );

    test('SHOULD throw a [ServerException] when a [FirebaseException] occurs',
        () async {
      when(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final methodCall = datasource.signIn;

      expect(
        methodCall(
          email: tEmail,
          password: tPassword,
        ),
        throwsA(isA<ServerException>()),
      );

      verify(
        () => authClient.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);
    });
  });

  group('sign up', () {
    test(
        'SHOULD finish successfully WHEN no '
        '[FirebaseAuthException] is threw', () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => userCredential);

      when(() => user.updateDisplayName(any()))
          .thenAnswer((_) async => Future.value());

      when(() => user.updatePhotoURL(any()))
          .thenAnswer((_) async => Future.value());

      final call = datasource.signUp(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
      );

      expect(
        call,
        completes,
      );

      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);

      await untilCalled(() => userCredential.user?.updateDisplayName(any()));
      await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

      verify(() => userCredential.user?.updateDisplayName(tFullName)).called(1);
      verify(() => userCredential.user?.updatePhotoURL(kDefaultAvatar))
          .called(1);

      verifyNoMoreInteractions(authClient);
    });

    test(
        'SHOULD throw a [ServerException] when a '
        '[FirebaseAuthException] occurs', () async {
      when(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tFirebaseAuthException);

      final call = datasource.signUp;

      expect(
        () => call(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        ),
        throwsA(isA<ServerException>()),
      );

      verify(
        () => authClient.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(1);
    });
  });

  group('update user', () {
    setUp(() => registerFallbackValue(MockAuthCredential()));
    test(
        'should update user displayName successfully when no [Exception] is '
        'thrown', () async {
      when(() => user.updateDisplayName(any())).thenAnswer(
        (_) async => Future.value(),
      );

      await datasource.updateUser(
        action: UpdateUserAction.displsyName,
        userData: tFullName,
      );

      verify(() => user.updateDisplayName(tFullName)).called(1);

      verifyNever(() => user.updatePhotoURL(any()));
      verifyNever(() => user.updateEmail(any()));
      verifyNever(() => user.updatePassword(any()));

      final firestoreUser =
          await cloudStoreClient.collection('users').doc(user.uid).get();

      expect(firestoreUser.exists, isTrue);
      expect(firestoreUser.data()!['fullName'], equals(tFullName));
    });
    test(
      'should update user profilePic successfully when no [Exception] is '
      'thrown',
      () async {
        final tProfPic = File('assets/images/onBoarding_background.png');

        when(() => userCredential.user!.updatePhotoURL(any()))
            .thenAnswer((_) async => Future.value());

        await datasource.updateUser(
          action: UpdateUserAction.profilePic,
          userData: tProfPic,
        );

        verify(() => userCredential.user!.updatePhotoURL(any())).called(1);
        verifyNever(() => userCredential.user!.updateDisplayName(any()));
        verifyNever(() => userCredential.user!.updateEmail(any()));
        verifyNever(() => userCredential.user!.updatePassword(any()));

        expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
      },
    );

    test(
      'should update user email successfully when no [Exception] is '
      'thrown',
      () async {
        when(() => userCredential.user!.updateEmail(any()))
            .thenAnswer((_) async => Future.value());

        await datasource.updateUser(
          action: UpdateUserAction.email,
          userData: tEmail,
        );

        verify(() => userCredential.user!.updateEmail(any())).called(1);
        verifyNever(() => userCredential.user!.updateDisplayName(any()));
        verifyNever(() => userCredential.user!.updatePhotoURL(any()));
        verifyNever(() => userCredential.user!.updatePassword(any()));

        final userFirestoreDoc =
            await cloudStoreClient.collection('users').doc(user.uid).get();

        expect(userFirestoreDoc.data()!['email'], tEmail);
      },
    );

    test(
      'should update user bio successfully when no [Exception] is '
      'thrown',
      () async {
        const newBio = 'My new bio';

        await datasource.updateUser(
          action: UpdateUserAction.bio,
          userData: newBio,
        );

        final userFirestoreDoc =
            await cloudStoreClient.collection('users').doc(user.uid).get();

        verifyNever(() => userCredential.user!.updateEmail(any()));
        verifyNever(() => userCredential.user!.updateDisplayName(any()));
        verifyNever(() => userCredential.user!.updatePhotoURL(any()));
        verifyNever(() => userCredential.user!.updatePassword(any()));

        expect(userFirestoreDoc.data()!['bio'], newBio);
      },
    );

    test(
      'should update user password successfully when no [Exception] is '
      'thrown',
      () async {
        when(() => user.updatePassword(any())).thenAnswer(
          (_) async => Future.value(),
        );

        when(() => user.reauthenticateWithCredential(any()))
            .thenAnswer((_) async => userCredential);

        when(() => user.email).thenReturn(tEmail);

        //debugPrint(userCredential.user!.email

        await datasource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode(
            {'oldPassword': 'myOldPassword', 'newPassword': tPassword},
          ),
        );

        verify(() => userCredential.user!.updatePassword(any())).called(1);
        verifyNever(() => userCredential.user!.updateEmail(any()));
        verifyNever(() => userCredential.user!.updateDisplayName(any()));
        verifyNever(() => userCredential.user!.updatePhotoURL(any()));

        final userFirestoreDoc = await cloudStoreClient
            .collection('users')
            .doc(
              docReference.id,
            )
            .get();

        expect(userFirestoreDoc.data()!['password'], null);
      },
    );
  });
}
