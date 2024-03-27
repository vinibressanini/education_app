import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/enums/update_user_action.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:education_app/src/auth/data/models/local_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({
    required FirebaseAuth authClient,
    required FirebaseStorage dbClient,
    required FirebaseFirestore cloudStoreClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseStorage _dbClient;
  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Ocurred',
        statusCode: e.code,
      );
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unknown Error',
        );
      }

      var userData = await _getUserData(result.user!.uid);

      if (userData.exists) return LocalUserModel.fromMap(userData.data()!);

      await _setUserData(result.user!, email);

      userData = await _getUserData(result.user!.uid);

      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Ocurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final userData = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userData.user?.updateDisplayName(fullName);
      await userData.user?.updatePhotoURL(kDefaultAvatar);

      await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Ocurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.password:
          final isLogged = _authClient.currentUser?.email != null;

          if (!isLogged) {
            throw const ServerException(
              message: 'User is not logged in',
              statusCode: 'Insufficient permission',
            );
          }

          final newData = jsonDecode(userData as String) as DataMap;

          await _authClient.currentUser!.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );

          await _authClient.currentUser!
              .updatePassword(newData['newPassword'] as String);
        case UpdateUserAction.displsyName:
          await _authClient.currentUser!.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});
        case UpdateUserAction.bio:
          await _updateUserData({'bio': userData});
        case UpdateUserAction.profilePic:
          final file = userData as File;

          final ref = _dbClient
              .ref()
              .child('profile_pics/${_authClient.currentUser?.uid}');
          await ref.putFile(file);

          final url = await ref.getDownloadURL();

          await _authClient.currentUser!.updatePhotoURL(url);
          await _updateUserData({'profilePic': url});
        case UpdateUserAction.email:
          await _authClient.currentUser?.updateEmail(userData as String);
          await _updateUserData({'email': userData});
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            points: 0,
            fullName: user.displayName ?? '',
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser!.uid)
        .update(data);
  }
}
